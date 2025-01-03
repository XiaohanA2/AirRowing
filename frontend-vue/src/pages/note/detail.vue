<template>
    <div class="note-detail-container">
        <el-card class="note-detail-card" shadow="hover">
            <div v-if="note">
                <h2 class="note-title">{{ note.title }}</h2>
                <div class="note-info">
                    <div class="image-carousel">
                        <el-carousel :interval="5000" type="card" height="300px">
                            <el-carousel-item v-for="(img, index) in note.imgUris" :key="index">
                                <img :src="img" alt="Note Image" class="carousel-image" />
                            </el-carousel-item>
                        </el-carousel>
                    </div>
                    <p class="note-content">{{ note.content }}</p>
                    <p class="note-updated">Last updated: {{ note.updateTime }}</p>
                    <div class="creator-info">
                        <img :src="note.avatar" alt="Creator Avatar" class="creator-avatar"
                            @click="goToUserDetail(note.creatorId)" />
                        <span class="creator-name">{{ note.creatorName }}</span>
                    </div>
                </div>

                <!-- 点赞和收藏 -->
                <div class="note-actions">
                    <el-button type="text" @click="toggleLike">
                        {{ isLiked ? '❤️' : '🤍' }}
                        {{ likeCount }}
                    </el-button>
                    <el-button type="text" @click="toggleCollect">
                        {{ isCollected ? '⭐' : '☆' }}
                        {{ collectCount }}
                    </el-button>
                    <el-button type="text" @click="scrollToComments">
                        💬 {{ commentCount }}
                    </el-button>
                </div>

                <!-- 评论区 -->
                <div class="comments-section">
                    <div class="comments-header">
                        <h3>评论 ({{ commentCount }})</h3>
                    </div>
                    
                    <!-- 评论输入框 -->
                    <div class="comment-form-container">
                        <el-input 
                            type="textarea" 
                            v-model="newComment.content"
                            :rows="3"
                            :maxlength="500"
                            :show-word-limit="true"
                            placeholder="写下你的评论..."
                            class="comment-input">
                        </el-input>
                        <div class="comment-form-actions">
                            <el-button 
                                type="primary" 
                                @click="submitComment"
                                :loading="loading.submit">
                                发布评论
                            </el-button>
                        </div>
                    </div>

                    <!-- 评论列表 -->
                    <div class="comments-list" v-loading="loading.comments">
                        <div v-if="comments.length === 0" class="no-comments">
                            暂无评论，快来抢沙发吧~
                        </div>
                        <div v-else class="comment-items">
                            <div v-for="comment in comments" 
                                 :key="comment.commentId" 
                                 class="comment-item">
                                <!-- 主评论 -->
                                <div class="comment-main">
                                    <div class="comment-user">
                                        <img :src="comment.userAvatar" 
                                             :alt="comment.userName" 
                                             class="user-avatar"
                                             @click="goToUserDetail(comment.userId)" />
                                        <div class="user-info">
                                            <span class="user-name">{{ comment.userName }}</span>
                                            <span class="comment-time">{{ comment.createTime }}</span>
                                        </div>
                                    </div>
                                    <div class="comment-content">{{ comment.content }}</div>
                                    <div class="comment-actions">
                                        <el-button 
                                            type="text" 
                                            size="small"
                                            @click="toggleCommentReply(comment)">
                                            回复
                                        </el-button>
                                        <el-button 
                                            v-if="comment.replies && comment.replies.length > 0"
                                            type="text" 
                                            size="small"
                                            @click="toggleReplies(comment.commentId)">
                                            {{ isRepliesCollapsed[comment.commentId] ? '展开回复' : '收起回复' }}
                                            ({{ comment.replies.length }})
                                        </el-button>
                                        <el-popconfirm
                                            v-if="isCurrentUser(comment.userId)"
                                            title="确定要删除这条评论吗？"
                                            @confirm="deleteComment(comment.commentId)">
                                            <template #reference>
                                                <el-button 
                                                    type="text" 
                                                    size="small"
                                                    class="delete-btn">
                                                    <i class="el-icon-delete"></i> 删除
                                                </el-button>
                                            </template>
                                        </el-popconfirm>
                                    </div>
                                </div>

                                <!-- 评论的回复输入框 -->
                                <div v-if="replyInputs[comment.commentId]" class="reply-form">
                                    <el-input 
                                        type="textarea" 
                                        v-model="replyContent[comment.commentId]"
                                        :rows="2"
                                        :maxlength="200"
                                        :show-word-limit="true"
                                        :placeholder="`回复 @${comment.userName}...`">
                                    </el-input>
                                    <div class="reply-form-actions">
                                        <div class="reply-tools">
                                            <el-popover
                                                placement="top"
                                                trigger="click"
                                                :width="240"
                                                popper-class="emoji-popover">
                                                <template #reference>
                                                    <el-button type="text" size="small" class="tool-btn">
                                                        <i class="el-icon-sunny"></i> 表情
                                                    </el-button>
                                                </template>
                                                <div class="emoji-grid">
                                                    <span v-for="emoji in commonEmojis" 
                                                          :key="emoji" 
                                                          @click="insertEmojiToComment(comment.commentId, emoji)"
                                                          class="emoji-item">
                                                        {{ emoji }}
                                                    </span>
                                                </div>
                                            </el-popover>
                                            <span class="input-tip">Ctrl + Enter 快捷发送</span>
                                        </div>
                                        <div class="reply-buttons">
                                            <el-button 
                                                size="small"
                                                @click="cancelCommentReply(comment.commentId)">
                                                取消
                                            </el-button>
                                            <el-button 
                                                type="primary" 
                                                size="small"
                                                :loading="loading.submit"
                                                @click="submitCommentReply(comment)">
                                                发送
                                            </el-button>
                                        </div>
                                    </div>
                                </div>

                                <!-- 回复列表 -->
                                <div v-if="comment.replies && comment.replies.length > 0" 
                                     class="replies-container"
                                     v-show="!isRepliesCollapsed[comment.commentId]">
                                    <div v-for="reply in comment.replies" 
                                         :key="reply.id" 
                                         class="reply-item">
                                        <div class="reply-main">
                                            <div class="reply-user">
                                                <img :src="reply.userAvatar" 
                                                     :alt="reply.userName" 
                                                     class="user-avatar-small"
                                                     @click="goToUserDetail(reply.userId)" />
                                                <div class="reply-info">
                                                    <div class="reply-header">
                                                        <span class="user-name">{{ reply.userName }}</span>
                                                        <span class="reply-to">
                                                            回复 
                                                            <span class="user-name">@{{ reply.replyToUserName }}</span>
                                                        </span>
                                                        <span class="reply-time">{{ reply.createTime }}</span>
                                                    </div>
                                                    <div class="reply-content">{{ reply.content }}</div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- 回复操作区 -->
                                        <div class="reply-operation" 
                                             :class="{ 'reply-operation-active': replyInputs[`${comment.commentId}-${reply.id}`] }">
                                            <!-- 回复操作按钮组 -->
                                            <div class="reply-actions-group" v-if="!replyInputs[`${comment.commentId}-${reply.id}`]">
                                                <div class="action-buttons">
                                                    <el-button 
                                                        type="text" 
                                                        size="small"
                                                        class="action-btn"
                                                        @click="toggleNestedReply(comment.commentId, reply)">
                                                        <i class="el-icon-chat-dot-round"></i> 回复
                                                    </el-button>
                                                    <el-divider direction="vertical" />
                                                    <el-dropdown 
                                                        trigger="click" 
                                                        @command="(cmd) => quickReplyAndSubmit(comment.commentId, reply, cmd)"
                                                        class="quick-reply-dropdown">
                                                        <el-button type="text" size="small" class="action-btn">
                                                            <i class="el-icon-magic-stick"></i> 快捷回复
                                                        </el-button>
                                                        <template #dropdown>
                                                            <el-dropdown-menu>
                                                                <el-dropdown-item 
                                                                    v-for="(text, index) in quickReplies" 
                                                                    :key="index" 
                                                                    :command="text">
                                                                    {{ text }}
                                                                </el-dropdown-item>
                                                            </el-dropdown-menu>
                                                        </template>
                                                    </el-dropdown>
                                                    <el-divider direction="vertical" />
                                                    <template v-if="isCurrentUser(reply.userId)">
                                                        <el-popconfirm
                                                            title="确定要删除这条回复吗？"
                                                            @confirm="deleteReply(comment.commentId, reply.id)">
                                                            <template #reference>
                                                                <el-button 
                                                                    type="text" 
                                                                    size="small"
                                                                    class="action-btn delete-btn">
                                                                    <i class="el-icon-delete"></i> 删除
                                                                </el-button>
                                                            </template>
                                                        </el-popconfirm>
                                                    </template>
                                                </div>
                                            </div>

                                            <!-- 内联回复框 -->
                                            <transition name="slide-fade">
                                                <div v-if="replyInputs[`${comment.commentId}-${reply.id}`]" 
                                                     class="inline-reply-box">
                                                    <el-input 
                                                        ref="replyInput"
                                                        type="textarea" 
                                                        v-model="replyContent[`${comment.commentId}-${reply.id}`]"
                                                        :maxlength="200"
                                                        :show-word-limit="true"
                                                        :rows="2"
                                                        :placeholder="`回复 @${reply.userName}...`"
                                                        @keyup.enter.ctrl="submitNestedReply(comment.commentId, reply)"
                                                        class="reply-input">
                                                    </el-input>
                                                    <div class="reply-box-actions">
                                                        <div class="reply-tools">
                                                            <el-popover
                                                                placement="top"
                                                                trigger="click"
                                                                :width="240"
                                                                popper-class="emoji-popover">
                                                                <template #reference>
                                                                    <el-button type="text" size="small" class="tool-btn">
                                                                        <i class="el-icon-sunny"></i> 表情
                                                                    </el-button>
                                                                </template>
                                                                <div class="emoji-grid">
                                                                    <span v-for="emoji in commonEmojis" 
                                                                          :key="emoji" 
                                                                          @click="insertEmoji(comment.commentId, reply.id, emoji)"
                                                                          class="emoji-item">
                                                                        {{ emoji }}
                                                                    </span>
                                                                </div>
                                                            </el-popover>
                                                            <span class="input-tip">Ctrl + Enter 快捷发送</span>
                                                        </div>
                                                        <div class="reply-buttons">
                                                            <el-button 
                                                                size="small"
                                                                @click="cancelNestedReply(comment.commentId, reply)">
                                                                取消
                                                            </el-button>
                                                            <el-button 
                                                                type="primary" 
                                                                size="small"
                                                                :loading="loading.submit"
                                                                @click="submitNestedReply(comment.commentId, reply)">
                                                                发送
                                                            </el-button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </transition>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 分页 -->
                        <div class="pagination-container">
                            <el-pagination
                                background
                                layout="prev, pager, next"
                                :total="pagination.total"
                                :page-size="pagination.size"
                                :current-page="pagination.page"
                                @current-change="handlePageChange">
                            </el-pagination>
                        </div>
                    </div>
                </div>
            </div>
            <div v-else>
                <p>Loading note details...</p>
            </div>
        </el-card>
    </div>
</template>

<script>
import { getNoteDetailService, addCommentService, getNoteCommentsService, getCommentRepliesService, getCommentCountService, deleteCommentService } from "@/api/note.js";
import { getUserInfoByIdService, getUserInfo } from "@/api/user.js";
import { ElMessage } from "element-plus";
import { dolikeNoteService, nolikeNoteService, doCollectService, unCollectService, noteCountService } from "@/api/collect.js";
export default {
    data() {
        return {
            note: null, // 当前笔记情
            comments: [], // 评论列表
            newComment: { content: "" }, // 新评论内容
            replyInputs: {}, // 控制每个评论的回复输入框是否显示
            replyContent: {}, // 存储每个评论的回复内容
            isLiked: false,
            isCollected: false,
            likeCount: 0,
            collectCount: 0,
            pagination: {
                page: 1,
                size: 10,
                total: 0
            },
            loading: {
                comments: false,
                replies: false,
                submit: false
            },
            activeReply: null, // 当前正在回复的评论
            commonEmojis: ['😊', '😂', '👍', '❤️', '🎉', '🤔', '👏', '🙏', '💪', '✨'],
            quickReplies: [
                '说得对！',
                '支持你的观点',
                '感谢分享',
                '学习',
                '期待更新'
            ],
            commentCount: 0, // 添加评论总数
            currentUserId: null, // 当前登录用户ID
            isRepliesCollapsed: {}, // 控制评论的回复是否折叠
        };
    },
    methods: {
        async fetchNoteCount() {
            const noteId = this.$route.params.id;
            if (!noteId) {
                console.warn("Note ID is invalid. Skipping fetchNoteCount.");
                return;
            }
            try {
                const response = await noteCountService({ noteId });
                console.log("笔记计数接口返回数据：", response);
                if (response.success) {
                    this.likeCount = response.data.likeTotal || 0;
                    this.collectCount = response.data.collectTotal || 0;
                    console.log("点赞数：", this.likeCount);
                    console.log("收藏数：", this.collectCount);
                } else {
                    // 接口返回的成功标识为 false可以在这里设置默认值
                    console.warn("Failed to fetch note count, using defaults.");
                    this.likeCount = 0;
                    this.collectCount = 0;
                }
            } catch (error) {
                // 捕获500错误，在控制台记录，但不弹错误提示，使用默认值兜底
                console.error("获取笔记计数信息失败，使用默认计数值:", error);
                this.likeCount = 0;
                this.collectCount = 0;
                // 可选：不使用 ElMessage 提示用户错误，将其默默处理
                // ElMessage.error("获取计数失败，已使用默认值");
            }
        },
        async fetchNoteDetail() {
            const noteId = this.$route.params.id;
            if (!noteId) {
                console.warn("Note ID is null or undefined. Skipping fetch.");
                return;
            }
            this.note = null;
            try {
                const response = await getNoteDetailService({ id: noteId });
                if (response.success) {
                    this.note = response.data;
                    this.isLiked = JSON.parse(localStorage.getItem(`note_${noteId}_liked`)) || false;
                    this.isCollected = JSON.parse(localStorage.getItem(`note_${noteId}_collected`)) || false;
                    await this.fetchNoteCount(); // 获取计数信息
                    await this.fetchCommentCount(); // 添加这行
                    this.fetchComments();
                } else {
                    //ElMessage.error(response.message || "Failed to fetch note details.");
                    console.error("获取笔记计数信息失败，使用默认计数值:", error);
                    this.likeCount = 0;
                    this.collectCount = 0;
                }
            } catch (error) {
                console.error("Error fetching note detail:", error);
                ElMessage.error("An error occurred while fetching note details.");
            }
        },
        async fetchComments() {
            const noteId = this.$route.params.id;
            this.loading.comments = true;
            try {
                const response = await getNoteCommentsService({ 
                    noteId, 
                    page: this.pagination.page, 
                    size: this.pagination.size 
                });
                
                if (response.success) {
                    console.log('Comments response:', response.data);
                    
                    if (response.data.records) {
                        this.comments = response.data.records;
                        this.comments.forEach(comment => {
                            console.log('Comment details:', {
                                commentId: comment.commentId,
                                userId: comment.userId,
                                userName: comment.userName,
                                currentUserId: this.currentUserId,
                                canDelete: this.isCurrentUser(comment.userId)
                            });
                        });
                        this.pagination.total = response.data.total;
                    } else {
                        this.comments = Array.isArray(response.data) ? response.data : [];
                        this.pagination.total = this.comments.length;
                    }
                    
                    console.log('处理后评论数据:', this.comments);
                    
                    if (this.comments.length > 0) {
                        await Promise.all(this.comments.map(comment => {
                            console.log('获取评论ID的回复:', comment.commentId);
                            return this.fetchReplies(comment.commentId);
                        }));
                    }
                } else {
                    ElMessage.warning(response.message || "获取评论失败");
                }
            } catch (error) {
                console.error("获取评论出错:", error);
                ElMessage.error("获取评论时发生错误");
            } finally {
                this.loading.comments = false;
            }
        },
        async fetchReplies(commentId) {
            if (!commentId) {
                console.warn('Invalid commentId:', commentId);
                return;
            }

            this.loading.replies = true;
            try {
                const response = await getCommentRepliesService({ commentId });
                console.log('Replies response for comment', commentId, ':', response);
                
                if (response.success) {
                    const commentIndex = this.comments.findIndex(
                        comment => comment.commentId === commentId
                    );
                    if (commentIndex !== -1) {
                        const replies = await Promise.all((response.data || []).map(async reply => {
                            if (reply.replyToUserId) {
                                try {
                                    const userResponse = await getUserInfoByIdService({ id: reply.replyToUserId });
                                    if (userResponse.success) {
                                        return {
                                            ...reply,
                                            replyToUserName: userResponse.data.nickName
                                        };
                                    }
                                } catch (error) {
                                    console.error('获取被回复用户信息失败:', error);
                                }
                            }
                            
                            return {
                                ...reply,
                                replyToUserName: this.comments[commentIndex].userName,
                                replyToUserId: this.comments[commentIndex].userId
                            };
                        }));

                        this.comments[commentIndex] = {
                            ...this.comments[commentIndex],
                            replies: replies
                        };
                    }
                }
            } catch (error) {
                console.error("获取回复出错:", error);
                ElMessage.error("获取回复失败");
            } finally {
                this.loading.replies = false;
            }
        },
        async submitComment() {
            if (!this.newComment.content.trim()) {
                ElMessage.warning("评论内容不能为空");
                return;
            }

            this.loading.submit = true;
            try {
                const response = await addCommentService({
                    noteId: this.$route.params.id,
                    content: this.newComment.content,
                    parentId: null // 一级评论无父评论
                });

                if (response.success) {
                    ElMessage.success("评论发布成功");
                    this.newComment.content = "";
                    this.pagination.page = 1;
                    await this.fetchCommentCount(); // 添加这行
                    await this.fetchComments();
                } else {
                    ElMessage.warning(response.message || "评论发布失败");
                }
            } catch (error) {
                console.error("发布评论出错:", error);
                ElMessage.error("发布评论时发生错误");
            } finally {
                this.loading.submit = false;
            }
        },
        showReplyInput(commentId) {
            this.replyInputs[commentId] = true;
        },
        async submitReply(parentCommentId) {
            const content = this.replyContent[parentCommentId]?.trim();
            if (!content) {
                ElMessage.warning("回复内容不能为空");
                return;
            }

            this.loading.submit = true;
            try {
                const response = await addCommentService({
                    noteId: this.$route.params.id,
                    content: content,
                    parentId: parentCommentId
                });

                if (response.success) {
                    ElMessage.success("回复发布成功");
                    this.replyContent[parentCommentId] = "";
                    this.replyInputs[parentCommentId] = false;
                    await this.fetchCommentCount(); // 添加这行
                    await this.fetchReplies(parentCommentId);
                } else {
                    ElMessage.warning(response.message || "回复发布失败");
                }
            } catch (error) {
                console.error("发布回复出错:", error);
                ElMessage.error("发布回复时发生错误");
            } finally {
                this.loading.submit = false;
            }
        },
        goToUserDetail(userId) {
            this.$router.push({ name: "UserDetail", params: { id: userId } });
        },
        async toggleLike() {
            const noteId = this.$route.params.id;
            const service = this.isLiked ? nolikeNoteService : dolikeNoteService;

            try {
                const response = await service({ id: noteId });
                if (response.success) {
                    this.isLiked = !this.isLiked;
                    localStorage.setItem(`note_${noteId}_liked`, JSON.stringify(this.isLiked));
                    await this.fetchNoteCount(); // 重新获取最新计数
                    ElMessage.success(this.isLiked ? "点赞成功" : "取消点赞成功");
                } else {
                    ElMessage.error(response.message || "操作失败");
                }
            } catch (error) {
                console.error("Error toggling like:", error);
                ElMessage.error("操作失败");
            }
        },
        async toggleCollect() {
            const noteId = this.$route.params.id;
            const service = this.isCollected ? unCollectService : doCollectService;

            try {
                const response = await service({ id: noteId });
                if (response.success) {
                    this.isCollected = !this.isCollected;
                    localStorage.setItem(`note_${noteId}_collected`, JSON.stringify(this.isCollected));
                    await this.fetchNoteCount(); // 重新获取最新计数
                    ElMessage.success(this.isCollected ? "收藏成功" : "取消收藏成功");
                } else {
                    ElMessage.error(response.message || "操作失败");
                }
            } catch (error) {
                console.error("Error toggling collect:", error);
                ElMessage.error("操作失败");
            }
        },
        async handlePageChange(page) {
            this.pagination.page = page;
            await this.fetchComments();
        },
        // 换一级评论的回复输入框显示
        toggleCommentReply(comment) {
            this.replyInputs = {
                ...this.replyInputs,
                [comment.commentId]: !this.replyInputs[comment.commentId]
            };
        },

        // 取消一级评论回复
        cancelCommentReply(commentId) {
            this.replyInputs[commentId] = false;
            this.replyContent[commentId] = '';
        },

        // 提交一级评论的回复
        async submitCommentReply(comment) {
            const content = this.replyContent[comment.commentId]?.trim();
            if (!content) {
                ElMessage.warning("回复内容不能为空");
                return;
            }

            this.loading.submit = true;
            try {
                const response = await addCommentService({
                    noteId: this.$route.params.id,
                    content: content,
                    parentId: comment.commentId,
                    replyToUserId: comment.userId
                });

                if (response.success) {
                    ElMessage.success("回复发布成功");
                    this.replyContent[comment.commentId] = "";
                    this.replyInputs[comment.commentId] = false;
                    await this.fetchCommentCount();
                    await this.fetchReplies(comment.commentId);
                } else {
                    ElMessage.warning(response.message || "回复发布失败");
                }
            } catch (error) {
                console.error("发布回复出错:", error);
                ElMessage.error("发布回复时发生错误");
            } finally {
                this.loading.submit = false;
            }
        },

        // 为一级评论插入表情
        insertEmojiToComment(commentId, emoji) {
            const content = this.replyContent[commentId] || '';
            this.replyContent[commentId] = content + emoji;
        },

        // 修改原有的 toggleReplyInput 方法名，专门用于嵌套回复
        toggleNestedReply(commentId, reply) {
            const key = `${commentId}-${reply.id}`;
            this.replyInputs = {
                ...this.replyInputs,
                [key]: !this.replyInputs[key]
            };
            this.activeReply = reply;
            
            if (this.replyInputs[key]) {
                this.$nextTick(() => {
                    const input = this.$refs.replyInput;
                    if (input && input.focus) {
                        input.focus();
                    }
                });
            }
        },

        // 插入表情
        insertEmoji(commentId, replyId, emoji) {
            const key = `${commentId}-${replyId}`;
            const content = this.replyContent[key] || '';
            this.replyContent[key] = content + emoji;
        },

        // 插入快捷回复
        insertQuickReply(commentId, replyId, text) {
            const key = `${commentId}-${replyId}`;
            this.replyContent[key] = text;
        },

        // 快捷回复并直接提交
        async quickReplyAndSubmit(commentId, reply, content) {
            this.loading.submit = true;
            try {
                const response = await addCommentService({
                    noteId: this.$route.params.id,
                    content: content,
                    parentId: commentId,
                    replyToUserId: reply.userId
                });

                if (response.success) {
                    ElMessage.success("回复发布成功");
                    await this.fetchReplies(commentId);
                    await this.fetchCommentCount(); // 添加这行
                } else {
                    ElMessage.warning(response.message || "回复发布失���");
                }
            } catch (error) {
                console.error("发布回复出错:", error);
                ElMessage.error("发布回复发生错误");
            } finally {
                this.loading.submit = false;
            }
        },
        async fetchCommentCount() {
            const noteId = this.$route.params.id;
            try {
                const response = await getCommentCountService({ noteId });
                if (response.success) {
                    this.commentCount = response.data || 0;
                } else {
                    console.warn("Failed to fetch comment count");
                    this.commentCount = 0;
                }
            } catch (error) {
                console.error("Error fetching comment count:", error);
                this.commentCount = 0;
            }
        },
        // 提交嵌套回复
        async submitNestedReply(commentId, replyTo) {
            const content = this.replyContent[`${commentId}-${replyTo.id}`]?.trim();
            if (!content) {
                ElMessage.warning("回复内容不能为空");
                return;
            }

            this.loading.submit = true;
            try {
                const response = await addCommentService({
                    noteId: this.$route.params.id,
                    content: content,
                    parentId: commentId,
                    replyToUserId: replyTo.userId
                });

                if (response.success) {
                    ElMessage.success("回复发布成功");
                    // 清空输入框和状态
                    this.replyContent[`${commentId}-${replyTo.id}`] = "";
                    this.replyInputs[`${commentId}-${replyTo.id}`] = false;
                    this.activeReply = null;
                    
                    // 重新获取评论数据
                    await this.fetchCommentCount();
                    await this.fetchReplies(commentId);
                } else {
                    ElMessage.warning(response.message || "回复发布失败");
                }
            } catch (error) {
                console.error("发布回复出错:", error);
                ElMessage.error("发布回复时发生错误");
            } finally {
                this.loading.submit = false;
            }
        },

        // 取消嵌套回复
        cancelNestedReply(commentId, reply) {
            if (!reply) return;
            
            const key = `${commentId}-${reply.id}`;
            this.replyInputs[key] = false;
            this.replyContent[key] = '';
            this.activeReply = null;
        },

        // 获取当前用户信息
        async getCurrentUser() {
            try {
                const response = await getUserInfo();
                console.log('Current user response:', response);

                if (response.success && response.data) {
                    this.currentUserId = response.data.id;
                    console.log('Set currentUserId to:', this.currentUserId);
                } else {
                    console.warn('Failed to get current user info:', response.message);
                    this.currentUserId = null;
                }
            } catch (error) {
                console.error('获取当前用户信息失败:', error);
                this.currentUserId = null;
            }
        },

        // 添加权限判断方法
        isCurrentUser(userId) {
            // 确保两个 ID 都转换为数字进行比较
            const currentId = Number(this.currentUserId);
            const targetId = Number(userId);
            
            const isMatch = currentId && targetId && currentId === targetId;
            console.log('Checking user permission:', {
                currentUserId: currentId,
                targetUserId: targetId,
                currentIdType: typeof currentId,
                targetIdType: typeof targetId,
                isMatch: isMatch
            });
            
            return isMatch;
        },

        // 修改删除方法，添加权限判断
        async deleteComment(commentId) {
            if (!this.currentUserId) {
                ElMessage.warning('请先登录');
                return;
            }

            console.log('尝试删除评论:', commentId);
            try {
                console.log('发送删除评论请求:', { commentId });
                const response = await deleteCommentService({ commentId });
                console.log('删除评论响应:', response);
                
                if (response.success) {
                    ElMessage.success('评论删除成功');
                    await this.fetchCommentCount();
                    await this.fetchComments();
                } else {
                    console.warn('删除评论失败:', response.message);
                    ElMessage.error(response.message || '删除失败');
                }
            } catch (error) {
                console.error('删除评论出错:', error);
                ElMessage.error('删除评论时发生错误');
            }
        },

        async deleteReply(commentId, replyId) {
            if (!this.currentUserId) {
                ElMessage.warning('请先登录');
                return;
            }

            console.log('试删除回复:', { commentId, replyId });
            try {
                console.log('发送删除回复请求:', { commentId: replyId });
                const response = await deleteCommentService({ commentId: replyId });
                console.log('删除回复响应:', response);
                
                if (response.success) {
                    ElMessage.success('回复删除成功');
                    await this.fetchCommentCount();
                    await this.fetchReplies(commentId);
                } else {
                    console.warn('删除回复失败:', response.message);
                    ElMessage.error(response.message || '删除失败');
                }
            } catch (error) {
                console.error('删除回复出错:', error);
                ElMessage.error('删除回复时发生错误');
            }
        },

        // 添加折叠功能
        toggleReplies(commentId) {
            this.isRepliesCollapsed = {
                ...this.isRepliesCollapsed,
                [commentId]: !this.isRepliesCollapsed[commentId]
            };
        }
    },
    async mounted() {
        await this.getCurrentUser();
        this.fetchNoteDetail();
    },
    watch: {
        "$route.params.id": {
            async handler(newId) {
                if (!newId) {
                    console.warn("Route param 'id' is invalid. Skipping fetch.");
                    this.note = null;
                    return;
                }
                this.note = null;
                await this.getCurrentUser(); // 重新获取用户信息
                await this.fetchNoteDetail();
            },
            immediate: true,
        },
    },
};
</script>


<style scoped>
.note-detail-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 73vh;
    /* 占满窗口高度 */
    overflow: hidden;
    /* 禁止外部滚动 */
    padding: 0;
    background-color: #f5f5f5;
}

.note-detail-card {
    width: 90%;
    max-width: 1200px;
    height: 100%;
    /* 尽可能盖窗口 */
    overflow-y: auto;
    /* 允内滚动 */
    padding: 20px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    background: #fff;
}

.note-title {
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 20px;
}

.note-info {
    display: flex;
    flex-direction: column;
    gap: 15px;
}

.image-carousel {
    width: 100%;
    height: 300px;
    margin-bottom: 15px;
}

.carousel-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    border-radius: 8px;
}

.note-content {
    font-size: 16px;
    line-height: 1.5;
}

.note-updated {
    font-size: 14px;
    color: #999;
}

.creator-info {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-top: 15px;
}

.creator-avatar {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    cursor: pointer;
}

.creator-name {
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
}

.comments-section {
    margin-top: 40px;
    padding: 20px;
    background: #fff;
    border-radius: 8px;
}

.comments-header {
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 1px solid #eee;
}

.comments-header h3 {
    font-size: 18px;
    color: #333;
    margin: 0;
}

/* 评论输入框 */
.comment-form-container {
    margin-bottom: 30px;
    padding: 20px;
    background: #f8f9fa;
    border-radius: 8px;
}

.comment-input {
    margin-bottom: 15px;
}

.comment-form-actions {
    display: flex;
    justify-content: flex-end;
}

/* 评论列表 */
.comment-items {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.comment-item {
    padding: 20px;
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

/* 评论主体 */
.comment-main {
    margin-bottom: 15px;
}

.comment-user {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 12px;
}

.user-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    cursor: pointer;
}

.user-avatar-small {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    cursor: pointer;
}

.user-info {
    display: flex;
    flex-direction: column;
}

.user-name {
    font-weight: 600;
    color: #333;
    font-size: 14px;
}

.comment-time, .reply-time {
    font-size: 12px;
    color: #999;
}

.comment-content {
    font-size: 14px;
    line-height: 1.6;
    color: #333;
    margin: 8px 0;
}

.comment-actions {
    display: flex;
    justify-content: flex-end;
    gap: 16px;
    margin-top: 8px;
}

/* 回复表单 */
.reply-form {
    margin: 15px 0;
    padding: 15px;
    background: #f8f9fa;
    border-radius: 8px;
}

.reply-form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 8px;
    margin-top: 10px;
}

/* 回复列表 */
.replies-container {
    margin-top: 15px;
    padding-left: 20px;
    border-left: 2px solid #f0f0f0;
}

.reply-item {
    position: relative;
    padding: 16px;
    margin-bottom: 12px;
    background: #f8f9fa;
    border-radius: 8px;
    transition: all 0.3s ease;
}

.reply-item:hover {
    background: #f0f2f5;
}

.reply-main {
    display: flex;
    flex-direction: column;
}

.reply-user {
    display: flex;
    gap: 12px;
    align-items: flex-start;
}

.reply-info {
    flex: 1;
}

.reply-header {
    display: flex;
    align-items: center;
    gap: 8px;
    flex-wrap: wrap;
}

.reply-content {
    margin-top: 8px;
    font-size: 14px;
    line-height: 1.6;
    color: #333;
}

.reply-operation {
    margin-top: 8px;
    padding: 8px 0;
    border-top: 1px solid #eee;
}

.reply-actions-group {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 8px;
}

.action-buttons {
    display: flex;
    align-items: center;
    gap: 16px;
}

.action-btn {
    display: flex;
    align-items: center;
    gap: 4px;
    color: #666;
    transition: all 0.3s ease;
}

.action-btn:hover {
    color: #409EFF;
    transform: translateY(-1px);
}

.inline-reply-box {
    margin-top: 12px;
    padding: 12px;
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.reply-input {
    margin-bottom: 8px;
}

.reply-box-actions {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-top: 8px;
    border-top: 1px solid #f0f0f0;
}

.reply-tools {
    display: flex;
    align-items: center;
    gap: 16px;
}

.tool-btn {
    display: flex;
    align-items: center;
    gap: 4px;
    color: #666;
}

.input-tip {
    font-size: 12px;
    color: #999;
}

.reply-buttons {
    display: flex;
    gap: 8px;
}

/* 表情选择器样式优化 */
.emoji-grid {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    gap: 8px;
    padding: 8px;
    background: #fff;
    border-radius: 4px;
}

.emoji-item {
    font-size: 20px;
    cursor: pointer;
    text-align: center;
    padding: 6px;
    border-radius: 4px;
    transition: all 0.2s ease;
}

.emoji-item:hover {
    background-color: #f0f0f0;
    transform: scale(1.1);
}

/* 过渡动画 */
.slide-fade-enter-active,
.slide-fade-leave-active {
    transition: all 0.3s ease;
}

.slide-fade-enter-from,
.slide-fade-leave-to {
    transform: translateY(-10px);
    opacity: 0;
}

/* 分割线样式 */
.el-divider--vertical {
    margin: 0 8px;
    height: 14px;
}

/* 快捷回复下拉菜单样式 */
:deep(.el-dropdown-menu) {
    padding: 4px 0;
}

:deep(.el-dropdown-menu__item) {
    line-height: 32px;
    padding: 0 16px;
    font-size: 14px;
}

:deep(.el-dropdown-menu__item:hover) {
    background-color: #f5f7fa;
    color: #409EFF;
}

/* 优化按钮样式 */
.el-button--text {
    padding: 0;
    height: auto;
    font-size: 13px;
    color: #666;
}

.el-button--text:hover {
    color: #409EFF;
}

/* 表情选择器弹出框样式 */
:deep(.emoji-popover) {
    padding: 8px;
    min-width: 240px;
}

/* 分页 */
.pagination-container {
    margin-top: 30px;
    display: flex;
    justify-content: center;
}

/* 无评论状态 */
.no-comments {
    text-align: center;
    padding: 40px 0;
    color: #999;
    font-size: 14px;
}

/* 动画效果 */
.comment-item {
    transition: transform 0.2s ease;
}

.comment-item:hover {
    transform: translateX(4px);
}

.reply-item {
    transition: transform 0.2s ease;
}

.reply-item:hover {
    transform: translateX(4px);
}

/* 删除按钮样式 */
.delete-btn {
    color: #f56c6c;
}

.delete-btn:hover {
    color: #f56c6c;
    opacity: 0.8;
}

/* 调整操作按钮间距 */
.comment-actions {
    display: flex;
    justify-content: flex-end;
    gap: 16px;
    margin-top: 8px;
}

/* 确认弹窗样式 */
:deep(.el-popconfirm__main) {
    margin: 8px 0;
    font-size: 14px;
}
</style>