<template>
  <div class="my-notes-container">
    <el-card class="note-detail-card" shadow="hover">
      <div v-if="loading" class="loading-spinner">
        <div class="spinner"></div>
      </div>

      <div v-else>
        <div v-if="error" class="error-message">
          {{ error }}
        </div>

        <div v-else>
          <div class="actions" v-if="status === 1">
            <button class="publish-btn" @click="openPublishModal">发布笔记</button>
          </div>

          <div class="notes-grid">
            <!-- 使用分页后的笔记数据 -->
            <div class="my-note-card" :class="{ 'is-top': note.isTop }" v-for="note in paginatedNotes" :key="note.id"
              @click="goToNoteDetail(note.id)">
              <!-- 修改图片显示部分 -->
              <div class="note-images">
                <img src="/assets/developer.png" alt="默认图片" class="note-image" />
                <img v-if="note.imgUris && note.imgUris.length > 0" 
                     :src="note.imgUris[0]" 
                     alt="" 
                     class="note-image" 
                     style="position: absolute; top: 0; left: 0;" />
              </div>
              <h3>{{ note.title }}</h3>
              <small>{{ formatDate(note.updateTime) }}</small>
              <div class="note-actions">
                <button class="edit-btn" @click.stop="editNote(note)" v-if="status === 1">编辑</button>
                <button class="top-btn" @click.stop="toggleTop(note)" :class="{ active: note.isTop }">
                  {{ note.isTop ? '取消置顶' : '置顶' }}
                </button>
                <button class="visibility-btn" @click.stop="toggleVisibility(note)" :class="{ active: note.visible === 1 }">
                  {{ note.visible === 1 ? '公开' : '仅自己可见' }}
                </button>
                <button class="delete-btn" v-if="status === 1" @click.stop="deleteNote(note)">
                  删除
                </button>
                <button class="restore-btn" v-else @click.stop="restoreNote(note)">
                  恢复
                </button>
              </div>
            </div>
          </div>

          <!-- 替换原有的加载更多按钮为分页器 -->
          <div class="pagination-container">
            <el-pagination
              v-model:current-page="currentPage"
              :page-size="pageSize"
              :total="myNotes.length"
              layout="prev, pager, next"
              @current-change="handlePageChange"
            />
          </div>
        </div>
      </div>

      <!-- 编辑笔记模态窗口 -->
      <transition name="fade">
        <div v-if="isEditModalOpen" class="modal-overlay" @click.self="closeEditModal">
          <div class="modal">
            <h2>编辑笔记</h2>
            <form @submit.prevent="submitEditNote" class="form">
              <label>
                标题:
                <input type="text" v-model="currentNote.title" required />
              </label>
              <label>
                内容:
                <textarea v-model="currentNote.content" required></textarea>
              </label>
              <!-- 图片上传部分 -->
              <label>
                上传图片:
                <input type="file" multiple @change="handleEditImageUpload" accept="image/*" />
              </label>
              <div class="image-previews">
                <div v-for="(img, index) in currentNote.imgUris" :key="index" class="image-preview">
                  <img :src="img" alt="预览图片" />
                  <button type="button" @click="removeImage(currentNote.imgUris, index)">×</button>
                </div>
              </div>
              <div class="form-buttons">
                <button type="submit" class="btn save-btn" :disabled="loading">保存修改</button>
                <button type="button" class="btn cancel-btn" @click="closeEditModal">取消</button>
              </div>
            </form>
          </div>
        </div>
      </transition>

      <!-- 发布笔记模态窗口 -->
      <transition name="fade">
        <div v-if="isPublishModalOpen" class="modal-overlay" @click.self="closePublishModal">
          <div class="modal">
            <h2>发布笔记</h2>
            <form @submit.prevent="submitPublishNote" class="form">
              <label>
                标题:
                <input type="text" v-model="newNote.title" required />
              </label>
              <label>
                内容:
                <textarea v-model="newNote.content" required></textarea>
              </label>
              <!-- 图片上传部分 -->
              <label>
                上传图片 (最多4张):
                <input 
                  type="file" 
                  multiple 
                  @change="handlePublishImageUpload" 
                  accept="image/*"
                  :disabled="newNote.imgUris.length >= 4" 
                />
              </label>
              <div class="image-previews">
                <div v-for="(img, index) in newNote.imgUris" :key="index" class="image-preview">
                  <img :src="img" alt="预览图片" />
                  <button type="button" @click="removeImage(newNote.imgUris, index)">×</button>
                </div>
              </div>
              <!-- <label>
              主题 ID:
              <input type="number" v-model="newNote.topicId" />
            </label> -->
              <div class="form-buttons">
                <button type="submit" class="btn save-btn" :disabled="loading">发布</button>
                <button type="button" class="btn cancel-btn" @click="closePublishModal">取消</button>
              </div>
            </form>
          </div>
        </div>
      </transition>

      <!-- 添加空状态显示 -->
      <div v-if="!loading && myNotes.length === 0" class="empty-state">
        <img src="/assets/developer.png" alt="没有笔记" />
        <h3>还没有笔记</h3>
        <p>点击"发布笔记"开始创作吧！</p>
      </div>

      <!-- 添加操作反馈提示 -->
      <transition name="fade">
        <div v-if="showMessage" class="message-toast" :class="messageType">
          {{ message }}
        </div>
      </transition>

    </el-card>
  </div>
</template>

<script>
import axios from 'axios';
import { getToken } from '@/composables/cookie';
import { ref, reactive, computed } from 'vue';
import { useRouter } from 'vue-router';

export default {
  setup() {
    const router = useRouter();
    const myNotes = ref([]);
    const userId = ref(null);
    const size = ref(10);
    const page = ref(1);
    const loading = ref(false);
    const error = ref(null);
    const noMoreNotes = ref(false);

    const isEditModalOpen = ref(false);
    const isPublishModalOpen = ref(false);
    const currentNote = reactive({
      id: null,
      title: "",
      content: "",
      updateTime: "",
      isTop: false,
      visible: 1,
      imgUris: [] // 初始化为数组
    });
    const newNote = reactive({
      type: 0,
      imgUris: [], // 初始化为数组
      title: "",
      content: "",
      topicId: 1
    });

    const status = ref(1); // 1: 正常展示, 2: 查看被删除的笔记

    // 添加分页相关的响应式变量
    const currentPage = ref(1);
    const pageSize = ref(9); // 每页显示9条笔记

    // 计算分页后的笔记
    const paginatedNotes = computed(() => {
      const startIndex = (currentPage.value - 1) * pageSize.value;
      const endIndex = startIndex + pageSize.value;
      return sortedNotes.value.slice(startIndex, endIndex);
    });

    // 处理页码改变
    const handlePageChange = (newPage) => {
      currentPage.value = newPage;
      // 如果接近末尾且还有更多数据，提前加载下一批
      if (newPage * pageSize.value > myNotes.value.length - pageSize.value && !noMoreNotes.value) {
        loadMoreNotes();
      }
    };

    // 计算属性：格式化日期
    const formatDate = (dateString) => {
      if (!dateString) return '';

      // 将后端返回的日期字符串转换为标准格式
      const [datePart, timePart] = dateString.split(' ');
      if (!datePart || !timePart) return '';

      const [year, month, day] = datePart.split('-');
      const [hour, minute, second] = timePart.split(':');

      const date = new Date(year, month - 1, day, hour, minute, second);

      // 检查日期是否有效
      if (isNaN(date.getTime())) return '';

      return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`;
    };

    // 获取笔记详情
    const fetchNoteDetails = async (note, token) => {
      try {
        const response = await axios.post(
          '/api/note/note/detail',
          { id: note.id },
          {
            headers: {
              'Content-Type': 'application/json',
              Authorization: `Bearer ${token}`,
            },
          }
        );

        if (response.data.success) {
          // 将imgUris和updateTime添加到笔记对象中
          note.imgUris = response.data.data.imgUris || [];
          note.updateTime = response.data.data.updateTime;
          // 如果需要其他详细信息，也可以在这里添加
        } else {
          console.error(`获取笔记详情失败（ID: ${note.id}）:`, response.data.message);
          note.imgUris = [];
        }
      } catch (err) {
        console.error(`获取笔记详情时出错（ID: ${note.id}）:`, err);
        note.imgUris = [];
      }
    };

    // 获取当前用户信息
    const fetchCurrentUser = async () => {
      try {
        const token = getToken();
        if (!token) {
          throw new Error('未找到认证信息，请重新登录。');
        }
        const response = await axios.get('/api/user/user/current', {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });
        if (response.data.success) {
          userId.value = response.data.data.id;
          fetchMyNotes();
        } else {
          throw new Error(response.data.message || '获取用户信息失败。');
        }
      } catch (err) {
        console.error('获取用户信息时出错:', err);
        error.value = err.message || '获取用户信息时出错。';
      }
    };

    // 获取用户的笔记
    const fetchMyNotes = async () => {
      if (!userId.value) {
        error.value = '无法获取用户 ID，无法获取笔记列表。';
        return;
      }
      try {
        loading.value = true;
        const token = getToken();
        const response = await axios.post(
          '/api/note/note/UserNoteList',
          {
            userId: userId.value,
            size: size.value * 2, // 增加每次加载的数量，确保有足够的数据用于分页
            page: page.value,
            status: status.value
          },
          {
            headers: {
              'Content-Type': 'application/json',
              Authorization: `Bearer ${token}`,
            },
          }
        );
        if (response.data.success) {
          const fetchedNotes = response.data.data.map(note => ({
            ...note,
            imgUris: note.imgUris || [], // 确保imgUris为数组
            isTop: !!note.isTop // 确保isTop为布尔类型
          }));
          if (fetchedNotes.length < size.value) {
            noMoreNotes.value = true;
          }

          // 并行获取所有笔记的详情
          const detailPromises = fetchedNotes.map(note => fetchNoteDetails(note, token));
          await Promise.all(detailPromises);

          // 将带有详情的笔记添加到myNotes中
          myNotes.value = [...myNotes.value, ...fetchedNotes];
        } else {
          throw new Error(response.data.message || '获取笔记列表失败。');
        }
      } catch (err) {
        console.error('获取笔记列表时出错:', err);
        error.value = err.message || '获取笔记列表时出错。';
      } finally {
        loading.value = false;
      }
    };

    // 计算属性：排序后的笔记
    const sortedNotes = computed(() => {
      return myNotes.value.slice().sort((a, b) => {
        if (a.isTop === b.isTop) {
          return new Date(b.updateTime) - new Date(a.updateTime);
        }
        return b.isTop - a.isTop;
      });
    });

    // 切换笔记状态
    const changeStatus = (newStatus) => {
      if (status.value !== newStatus) {
        status.value = newStatus;
        // 重置笔记列表和分页信息
        myNotes.value = [];
        page.value = 1;
        noMoreNotes.value = false;
        // 重新获取笔记
        fetchMyNotes();
      }
    };

    // 加载更多笔记
    const loadMoreNotes = () => {
      if (!noMoreNotes.value && !loading.value) {
        page.value++;
        fetchMyNotes();
      }
    };

    // 编辑笔记
    const editNote = (note) => {
      Object.assign(currentNote, note);
      // 确保imgUris是数组
      currentNote.imgUris = note.imgUris ? [...note.imgUris] : [];
      isEditModalOpen.value = true;
    };

    // 提交编辑笔记
    const submitEditNote = async () => {
      try {
        loading.value = true;
        const token = getToken();
        const response = await axios.post(
          '/api/note/note/update',
          {
            id: currentNote.id,
            type: 0,  // 设置默认type为0
            title: currentNote.title,
            content: currentNote.content,
            imgUris: currentNote.imgUris,
            topicId: 1,  // 设置默认topicId为1
            videoUri: null  // 添加videoUri字段，设为null
          },
          {
            headers: {
              'Content-Type': 'application/json',
              Authorization: `Bearer ${token}`,
            },
          }
        );
        if (response.data.success) {
          // 更新笔记列表
          const index = myNotes.value.findIndex(note => note.id === currentNote.id);
          if (index !== -1) {
            myNotes.value[index] = {
              ...myNotes.value[index],
              title: currentNote.title,
              content: currentNote.content,
              imgUris: [...currentNote.imgUris],
              updateTime: new Date().toISOString(),
              isTop: currentNote.isTop
            };
          }
          showToast('笔记已更新', 'success');  // 使用 showToast 替代 alert
          closeEditModal();
        } else {
          throw new Error(response.data.message || '更新笔记失败。');
        }
      } catch (err) {
        console.error('更新笔记时出错:', err);
        showToast(err.message || '更新笔记时出错。', 'error');  // 使用 showToast 替代 alert
      } finally {
        loading.value = false;
      }
    };

    // 关闭编辑模态窗口
    const closeEditModal = () => {
      isEditModalOpen.value = false;
      // 重置当前笔记
      Object.assign(currentNote, {
        id: null,
        title: "",
        content: "",
        updateTime: "",
        isTop: false,
        visible: 1,
        imgUris: []
      });
    };

    // 发布笔记
    const openPublishModal = () => {
      isPublishModalOpen.value = true;
    };

    const closePublishModal = () => {
      isPublishModalOpen.value = false;
      // 重置新笔记
      Object.assign(newNote, {
        type: 0,
        imgUris: [],
        title: "",
        content: "",
        topicId: 1
      });
    };

    const submitPublishNote = async () => {
      try {
        loading.value = true;
        const token = getToken();
        const response = await axios.post(
          '/api/note/note/publish',
          {
            type: newNote.type,
            imgUris: newNote.imgUris,  // 发送图片URL数组（MinIO生成的访问链接）
            title: newNote.title,
            content: newNote.content,
            topicId: newNote.topicId
          },
          {
            headers: {
              'Content-Type': 'application/json',
              Authorization: `Bearer ${token}`,
            },
          }
        );
        if (response.data.success) {
          alert('笔记已发布。');
          console.log(newNote.imgUris);
          // 重新加载笔记列表
          myNotes.value = [];
          page.value = 1;
          noMoreNotes.value = false;
          fetchMyNotes();
          closePublishModal();
        } else {
          throw new Error(response.data.message || '发布笔记失败。');
        }
      } catch (err) {
        console.error('发布笔记时出错:', err);
        alert(err.message || '发布笔记���出错。');
      } finally {
        loading.value = false;
      }
    };

    // 处理图片上传（发布笔记）
    const handlePublishImageUpload = async (event) => {
      const files = event.target.files;
      if (!files.length) return;

      // 检查是否超过最大图片数量限制
      if (newNote.imgUris.length + files.length > 4) {
        alert('最多只能上传4张图片');
        event.target.value = ''; // 清空文件输入
        return;
      }

      const uploadedImageUrls = [];

      for (let file of files) {
        const formData = new FormData();
        formData.append('file', file);

        try {
          const response = await axios.post('/file/upload', formData, {
            headers: {
              'Content-Type': 'multipart/form-data',
              'Authorization': `Bearer ${getToken()}`,
            },
          });

          if (response.data.success) {
            uploadedImageUrls.push(response.data.data);
          } else {
            throw new Error(response.data.message || '图片上传失败');
          }
        } catch (err) {
          console.error('上传图片失败:', err);
          alert('上传图片失败: ' + (err.response?.data?.message || err.message));
          return;
        }
      }

      // 将所有上传的图片URL添加到 newNote.imgUris 中
      newNote.imgUris = [...newNote.imgUris, ...uploadedImageUrls];
      event.target.value = '';
    };

    // 处理图片上传（编辑笔记）
    const handleEditImageUpload = async (event) => {
      const files = event.target.files;
      if (!files.length) return;

      const uploadedImageUrls = [];

      for (let file of files) {
        const formData = new FormData();
        formData.append('file', file); // 根据后端接口文档，字段名为 'file'

        try {
          // 上传文件到后端
          const response = await axios.post('/file/upload', formData, {
            headers: {
              'Content-Type': 'multipart/form-data',
              // 如果需要认证，可以添加 Authorization 头
              'Authorization': `Bearer ${getToken()}`,
            },
          });

          if (response.data.success) {
            // 获取图片URL并添加到数组中
            uploadedImageUrls.push(response.data.data);
          } else {
            throw new Error(response.data.message || '图片上传失败');
          }
        } catch (err) {
          console.error('上传图片失败:', err);
          alert('上传图片失败: ' + (err.response?.data?.message || err.message));
          return; // 如果有一个文件上传失败，可以选择停止后续上传
        }
      }

      // 将所有上传的图片URL添加到 currentNote.imgUris 中
      currentNote.imgUris = [...currentNote.imgUris, ...uploadedImageUrls];

      // 清空文件输入
      event.target.value = '';
    };

    // 移除图片
    const removeImage = (imgUrisArray, index) => {
      imgUrisArray.splice(index, 1);
    };

    // 删除笔记
    const deleteNote = async (note) => {
      if (!confirm('确定要删除这篇笔记吗？')) return;
      try {
        loading.value = true;
        const token = getToken();
        const response = await axios.post(
          '/api/note/note/delete',
          {
            type: note.type,
            videoUri: note.videoUri || null,
            title: note.title,
            content: note.content,
            topicId: note.topicId,
            id: note.id
          },
          {
            headers: {
              'Content-Type': 'application/json',
              Authorization: `Bearer ${token}`,
            },
          }
        );
        if (response.data.success) {
          alert('笔记已删除。');
          // 从列表中移除
          myNotes.value = myNotes.value.filter(n => n.id !== note.id);
        } else {
          throw new Error(response.data.message || '删除笔记失败。');
        }
      } catch (err) {
        console.error('删除笔记时出错:', err);
        alert(err.message || '删除笔记时出错。');
      } finally {
        loading.value = false;
      }
    };

    // 恢复已删除的笔记
    const restoreNote = async (note) => {
      try {
        loading.value = true;
        const token = getToken();
        const response = await axios.post(
          '/api/note/note/restore', // 确保后端有此 API
          {
            id: note.id
          },
          {
            headers: {
              'Content-Type': 'application/json',
              Authorization: `Bearer ${token}`,
            },
          }
        );
        if (response.data.success) {
          alert('笔记已恢复。');
          // 从已删除的列表中移除
          myNotes.value = myNotes.value.filter(n => n.id !== note.id);
        } else {
          throw new Error(response.data.message || '恢复笔记失败。');
        }
      } catch (err) {
        console.error('恢复笔记时出错:', err);
        alert(err.message || '恢复笔记时出错。');
      } finally {
        loading.value = false;
      }
    };

    // 置顶或取消置顶笔记
    const toggleTop = async (note) => {
      try {
        loading.value = true;
        const token = getToken();
        const response = await axios.post(
          '/api/note/note/top',
          {
            id: note.id,
            isTop: !note.isTop
          },
          {
            headers: {
              'Content-Type': 'application/json',
              Authorization: `Bearer ${token}`,
            },
          }
        );
        if (response.data.success) {
          note.isTop = !note.isTop;
          alert(note.isTop ? '笔记已置顶。' : '笔记已取消置顶。');
          // 无需手动排序，因为 sortedNotes 会自动响应变化
        } else {
          throw new Error(response.data.message || '操作失败。');
        }
      } catch (err) {
        console.error('置顶笔记时出错:', err);
        alert(err.message || '操作时出错。');
      } finally {
        loading.value = false;
      }
    };

    // 切换笔记可见性
    const toggleVisibility = async (note) => {
      try {
        loading.value = true;
        const token = getToken();
        const response = await axios.post(
          '/api/note/note/visible/onlyme',
          {
            id: note.id,
            visible: note.visible === 1 ? 0 : 1 // 修正字段名和逻辑
          },
          {
            headers: {
              'Content-Type': 'application/json',
              Authorization: `Bearer ${token}`,
            },
          }
        );
        if (response.data.success) {
          note.visible = note.visible === 1 ? 0 : 1;
          alert(note.visible === 1 ? '笔记现在公开可见。' : '笔记现在仅自己可见。');
        } else {
          throw new Error(response.data.message || '操作失败。');
        }
      } catch (err) {
        console.error('切换可见性时出错:', err);
        alert(err.message || '操作时出错。');
      } finally {
        loading.value = false;
      }
    };

    // 组件挂载时获取用户信息和初始笔记
    fetchCurrentUser();

    // 修改跳转函数
    const goToNoteDetail = (id) => {
      router.push({
        name: 'NoteDetail',
        params: {
          id,
          userId: userId.value // 使用已有的 userId
        }
      });
    };

    // 在 setup 中添加消息提示相关的响应式变量
    const showMessage = ref(false);
    const message = ref('');
    const messageType = ref('success');

    // 添加显示消息的方法
    const showToast = (msg, type = 'success') => {
      message.value = msg;
      messageType.value = type;
      showMessage.value = true;
      setTimeout(() => {
        showMessage.value = false;
      }, 3000);
    };

    return {
      myNotes,
      sortedNotes, // 添加计算属性到返回对象
      status, // 添加 status 变量
      loading,
      error,
      noMoreNotes,
      loadMoreNotes,
      changeStatus, // 添加过滤方法到返回对象
      editNote,
      isEditModalOpen,
      currentNote,
      submitEditNote,
      closeEditModal,
      formatDate,
      isPublishModalOpen,
      openPublishModal,
      closePublishModal,
      newNote,
      submitPublishNote,
      deleteNote,
      restoreNote, // 添加恢复方法到返回对象
      toggleTop,
      toggleVisibility,
      handlePublishImageUpload,
      handleEditImageUpload,
      removeImage,
      goToNoteDetail,
      currentPage,
      pageSize,
      paginatedNotes,
      handlePageChange,
      showMessage,
      message,
      messageType,
      showToast,
    };
  },
};
</script>

<style scoped>
.my-notes-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 73vh;
  width: 100%;
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
  /* 尽可能覆盖窗口 */
  overflow-y: auto;
  /* 允许内容滚动 */
  padding: 20px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  border-radius: 10px;
  background: #fff;
}


h1 {
  text-align: center;
  margin-bottom: 30px;
  color: #343a40;
}

/* 过滤按钮样式 */
.filter-actions {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
  gap: 10px;
}

.filter-btn {
  padding: 8px 16px;
  font-size: 1em;
  color: #fff;
  background-color: #6c757d;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.filter-btn.active {
  background-color: #007bff;
}

.filter-btn:hover:not(.active) {
  background-color: #5a6268;
}

.actions {
  display: flex;
  justify-content: flex-end;
  margin-bottom: 20px;
}

.publish-btn {
  padding: 10px 20px;
  font-size: 1em;
  color: #fff;
  background-color: #17a2b8;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.publish-btn:hover {
  background-color: #138496;
}

.notes-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  margin-bottom: 20px;
}

.my-note-card {
  background: #ffffff;
  padding: 20px;
  border-radius: 15px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  position: relative;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  flex-direction: column;
  cursor: pointer;
  border: 1px solid rgba(0, 0, 0, 0.05);
}

.my-note-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.12);
  border-color: rgba(0, 123, 255, 0.3);
}

.my-note-card.is-top {
  border-left: 5px solid #28a745;
}

.my-note-card h3 {
  font-size: 1.5em;
  margin: 15px 0 10px 0;
  color: #007bff;
}

.my-note-card p {
  font-size: 1em;
  color: #555;
  margin-bottom: 15px;
  flex-grow: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  /* 显示三行 */
  -webkit-box-orient: vertical;
}

.my-note-card small {
  font-size: 0.8em;
  color: #999;
}

/* 修改图片相关样式 */
.note-images {
  width: 100%;
  margin-bottom: 15px;
  position: relative;
  height: 200px;
  overflow: hidden;
  border-radius: 10px;
  background: #f8f9fa;
}

.note-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.note-images:hover .note-image {
  transform: scale(1.05);
}

.note-actions {
  display: flex;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 15px;
}

.edit-btn,
.delete-btn,
.top-btn,
.visibility-btn,
.restore-btn {
  padding: 6px 12px;
  font-size: 0.9em;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 4px;
  font-weight: 500;
}

.edit-btn {
  background-color: #ffc107;
  color: #212529;
}

.edit-btn:hover {
  background-color: #e0a800;
}

.delete-btn {
  background-color: #dc3545;
  color: #fff;
}

.delete-btn:hover {
  background-color: #c82333;
}

.restore-btn {
  background-color: #17a2b8;
  color: #fff;
}

.restore-btn:hover {
  background-color: #138496;
}

.top-btn {
  background-color: #28a745;
  color: #fff;
}

.top-btn.active {
  background-color: #218838;
}

.top-btn:hover:not(.active) {
  background-color: #218838;
}

.visibility-btn {
  background-color: #17a2b8;
  color: #fff;
}

.visibility-btn.active {
  background-color: #138496;
}

.visibility-btn:hover:not(.active) {
  background-color: #138496;
}

.load-more-container {
  display: flex;
  justify-content: center;
  margin-top: 30px;
}

.load-more {
  padding: 10px 20px;
  font-size: 1em;
  color: #fff;
  background-color: #28a745;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.load-more:disabled {
  background-color: #6c757d;
  cursor: not-allowed;
}

.load-more:hover:not(:disabled) {
  background-color: #218838;
}

.error-message {
  color: red;
  text-align: center;
  margin-top: 20px;
  font-weight: bold;
}

.loading-spinner {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 200px;
}

.loading-spinner::after {
  content: "";
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #007bff;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* 模态窗口样式 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal {
  background: #ffffff;
  padding: 30px;
  border-radius: 20px;
  width: 90%;
  max-width: 600px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  animation: modalFadeIn 0.3s ease;
}

@keyframes modalFadeIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.modal h2 {
  margin-bottom: 20px;
  color: #343a40;
}

.form {
  display: flex;
  flex-direction: column;
}

.form label {
  margin-bottom: 15px;
  color: #333;
  font-weight: bold;
}

.form input,
.form textarea {
  width: 100%;
  padding: 12px;
  margin-top: 8px;
  border: 2px solid #e9ecef;
  border-radius: 8px;
  box-sizing: border-box;
  transition: border-color 0.3s ease;
}

.form input:focus,
.form textarea:focus {
  outline: none;
  border-color: #007bff;
  box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
}

.image-previews {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 10px;
}

.image-preview {
  position: relative;
  width: 100px;
  height: 100px;
}

.image-preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 5px;
}

.image-preview button {
  position: absolute;
  top: 5px;
  right: 5px;
  background-color: rgba(220, 53, 69, 0.8);
  border: none;
  color: #fff;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  cursor: pointer;
  font-size: 0.8em;
  line-height: 20px;
  text-align: center;
  padding: 0;
}

.image-preview button:hover {
  background-color: rgba(220, 53, 69, 1);
}

.form-buttons {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}

.save-btn {
  background-color: #28a745;
  color: #fff;
  border: none;
  padding: 8px 16px;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.save-btn:hover {
  background-color: #218838;
}

.cancel-btn {
  background-color: #6c757d;
  color: #fff;
  border: none;
  padding: 8px 16px;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.cancel-btn:hover {
  background-color: #5a6268;
}

/* 过渡效果 */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .notes-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .my-note-card p {
    height: 60px;
    -webkit-line-clamp: 2;
  }
}

@media (max-width: 480px) {
  .notes-grid {
    grid-template-columns: 1fr;
  }

  .my-note-card p {
    height: 80px;
    -webkit-line-clamp: 3;
  }

  .modal {
    padding: 20px;
  }

  .form-buttons {
    flex-direction: column;
    align-items: stretch;
  }

  .save-btn,
  .cancel-btn {
    width: 100%;
  }

  .image-preview {
    width: 80px;
    height: 80px;
  }

  .note-image {
    max-height: 150px;
  }

  .note-images img {
    width: 100%;
  }
}

/* 修改分页器容器样式 */
.pagination-container {
  display: flex;
  justify-content: center;
  padding: 20px 0;
  margin-top: 30px;
}

/* 添加分页器组件样式 */
:deep(.el-pagination) {
  text-align: center;
  font-size: 14px;
  padding: 10px 20px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

:deep(.el-pagination .el-pager li) {
  min-width: 32px;
  height: 32px;
  line-height: 32px;
  border-radius: 4px;
  margin: 0 3px;
  font-weight: 500;
}

:deep(.el-pagination .el-pager li.active) {
  background-color: #409eff;
  color: #fff;
}

:deep(.el-pagination .btn-prev),
:deep(.el-pagination .btn-next) {
  min-width: 32px;
  height: 32px;
  border-radius: 4px;
  padding: 0;
  margin: 0 3px;
}

/* 响应式调整 */
@media (max-width: 480px) {
  :deep(.el-pagination) {
    font-size: 12px;
    padding: 8px 12px;
  }

  :deep(.el-pagination .el-pager li) {
    min-width: 28px;
    height: 28px;
    line-height: 28px;
    margin: 0 2px;
  }

  :deep(.el-pagination .btn-prev),
  :deep(.el-pagination .btn-next) {
    min-width: 28px;
    height: 28px;
  }
}

/* 添加空状态样式 */
.empty-state {
  text-align: center;
  padding: 40px;
  color: #6c757d;
}

.empty-state img {
  width: 120px;
  margin-bottom: 20px;
  opacity: 0.5;
}

/* 添加消息提示样式 */
.message-toast {
  position: fixed;
  top: 20px;
  right: 20px;
  padding: 10px 20px;
  background-color: #fff;
  border-radius: 5px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  color: #333;
  font-size: 1em;
  font-weight: bold;
  animation: toastFadeIn 0.3s ease;
}

@keyframes toastFadeIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.message-toast.success {
  background-color: #dff0d8;
  border-color: #d6e9c6;
}

.message-toast.error {
  background-color: #f2dede;
  border-color: #ebccd1;
}

/* 添加禁用状态的样式 */
input[type="file"]:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* 可以添加一个提示文字显示剩余可上传数量 */
.image-upload-info {
  font-size: 0.8em;
  color: #666;
  margin-top: 4px;
}
</style>
