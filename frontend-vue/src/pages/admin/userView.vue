<template>
  <div class="user-profile-container">
    <!-- 面包屑导航 -->
    <el-breadcrumb separator="/">
      <el-breadcrumb-item to="/admin/index">首页</el-breadcrumb-item>
      <el-breadcrumb-item>用户详情</el-breadcrumb-item>
    </el-breadcrumb>

    <!-- 用户基本信息卡片 -->
    <el-card class="user-profile-card">
      <div class="user-info">
        <el-image :src="userInfo.avatar || defaultAvatar" fit="cover" class="user-avatar" lazy />
        <div class="user-details">
          <h2 class="user-name">{{ userInfo.nickName || '未知用户' }}</h2>
          <p class="user-introduction">{{ userInfo.introduction || '这个人很懒，什么都没写~' }}</p>
          <div class="user-stats">
            <el-tag type="success">粉丝 {{ userStats.fansTotal }}</el-tag>
            <el-tag type="info">关注 {{ userStats.followingTotal }}</el-tag>
            <el-tag type="primary">笔记 {{ userStats.noteTotal }}</el-tag>
            <el-tag type="danger">点赞 {{ userStats.likeTotal }}</el-tag>
            <el-tag>收藏 {{ userStats.collectTotal }}</el-tag>
          </div>
          <el-button type="primary" size="small" @click="toggleFollow" v-if="!isSelf">
            {{ isFollowing ? '取消关注' : '关注' }}
          </el-button>
        </div>
      </div>
    </el-card>

    <!-- 笔记列表 -->
    <el-card class="notes-container">
      <h2>笔记列表</h2>
      <div class="notes-scroll-wrapper" v-loading="loading">
        <div class="notes-scroll">
          <div v-for="note in notes" :key="note.id" class="note-card hover-effect" @click="goToNoteDetail(note.id)">
            <el-card shadow="always">
              <el-image v-if="note.imgUris && note.imgUris.length > 0" :src="note.imgUris[0]" fit="cover"
                class="note-image" />
              <div class="note-info">
                <h3 class="note-title">{{ note.title }}</h3>
                <p class="note-content">{{ note.content }}</p>
                <div class="note-date">
                  <el-icon>
                    <Calendar />
                  </el-icon>
                  <span>{{ formatDate(note.updateTime) }}</span>
                </div>
              </div>
            </el-card>
          </div>
        </div>
      </div>
      <div class="pagination">
        <el-pagination background layout="prev, pager, next" :page-size="size" :current-page.sync="page"
          @current-change="fetchUserNotes" />
      </div>
    </el-card>

    <!-- 增强界面内容 -->
    <div class="additional-section">
      <h2>推荐用户</h2>
      <div class="recommended-users">
        <div v-for="user in recommendedUsers" :key="user.id" class="recommended-user">
          <el-image :src="user.avatar || defaultAvatar" class="recommended-avatar" fit="cover" />
          <div class="recommended-info">
            <h3 class="recommended-name">{{ user.nickName || '未知用户' }}</h3>
            <p class="recommended-followers">粉丝：{{ user.followers }}</p>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import axios from 'axios';
import { getToken } from '@/composables/cookie';
import { Calendar } from '@element-plus/icons-vue';
import { ElMessage } from 'element-plus';
import { followUserApi, unfollowUserApi } from '@/api/admin/user';

const route = useRoute();
const router = useRouter();

const userInfo = ref({});
const userStats = ref({});
const notes = ref([]);
const loading = ref(false);
const page = ref(1);
const size = ref(10);
const isFollowing = ref(false);
const defaultAvatar =
  'https://img.quanxiaoha.com/quanxiaoha/f97361c0429d4bb1bc276ab835843065.jpg';
const isSelf = ref(false);

const recommendedUsers = ref([
  { id: 1, nickName: 'Alice', avatar: '', followers: 120 },
  { id: 2, nickName: 'Bob', avatar: '', followers: 80 },
  { id: 3, nickName: 'Charlie', avatar: '', followers: 150 },
]);

const formatDate = (dateString) => {
  if (!dateString) return '';
  try {
    const date = new Date(dateString);
    if (isNaN(date.getTime())) {
      return '';
    }
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
  } catch (error) {
    console.error('日期格式化错误:', error);
    return '';
  }
};

const fetchUserInfo = async () => {
  try {
    const token = getToken();
    const [userResponse, currentUserResponse] = await Promise.all([
      axios.post(
        '/api/user/user/findById',
        { id: route.params.userId },
        { headers: { Authorization: `Bearer ${token}` } }
      ),
      axios.get('/api/user/user/current', {
        headers: { Authorization: `Bearer ${token}` }
      })
    ]);

    if (userResponse.data.success) {
      userInfo.value = userResponse.data.data;
      if (!userInfo.value.avatar) {
        userInfo.value.avatar = defaultAvatar;
      }
    }

    if (currentUserResponse.data.success) {
      isSelf.value = currentUserResponse.data.data.id === Number(route.params.userId);
    }
  } catch (error) {
    console.error('获取用户信息失败:', error);
  }
};

const fetchUserStats = async () => {
  try {
    const token = getToken();
    const response = await axios.post(
      '/api/count/count/user',
      { userId: route.params.userId },
      { headers: { Authorization: `Bearer ${token}` } }
    );
    if (response.data.success) {
      userStats.value = response.data.data;
    }
  } catch (error) {
    console.error('获取用户统计信息失败:', error);
  }
};

const checkFollowStatus = async () => {
  if (isSelf.value) {
    isFollowing.value = false;
    return;
  }

  try {
    const userId = route.params.userId;
    await followUserApi(userId);
    isFollowing.value = true;
  } catch (error) {
    if (error.response?.data?.errorCode === 'RELATION-20004') {
      // 如果返回已关注错误，说明用户已经关注了
      isFollowing.value = true;
    } else if (error.response?.data?.errorCode === 'RELATION-20001') {
      // 如果是试图关注自己
      isSelf.value = true;
      isFollowing.value = false;
    } else {
      // 其他错误说明未关注
      isFollowing.value = false;
    }
  }
};

const toggleFollow = async () => {
  if (isSelf.value) {
    ElMessage({
      type: 'warning',
      message: '无法关注自己'
    });
    return;
  }

  try {
    const userId = route.params.userId;
    const response = isFollowing.value
      ? await unfollowUserApi(userId)
      : await followUserApi(userId);
      
    if (response.success) {
      isFollowing.value = !isFollowing.value;
      // 更新粉丝数量
      await fetchUserStats();
      ElMessage({
        type: 'success',
        message: isFollowing.value ? '关注成功' : '取消关注成功'
      });
    }
  } catch (error) {
    if (error.response?.data?.errorCode === 'RELATION-20004') {
      // 已经关注的情况
      isFollowing.value = true;
      ElMessage({
        type: 'warning',
        message: '您已经关注了该用户'
      });
    } else if (error.response?.data?.errorCode === 'RELATION-20001') {
      // 试图关注自己的情况
      ElMessage({
        type: 'warning',
        message: '无法关注自己'
      });
    } else {
      console.error(isFollowing.value ? '取消关注失败:' : '关注失败:', error);
      ElMessage({
        type: 'error',
        message: error.response?.data?.message || (isFollowing.value ? '取消关注失败' : '关注失败')
      });
    }
  }
};

const fetchUserNotes = async () => {
  loading.value = true;
  try {
    const token = getToken();
    const response = await axios.post(
      '/api/note/note/UserNoteList',
      { userId: route.params.userId, page: page.value, size: size.value, visible: 0 },
      { headers: { Authorization: `Bearer ${token}` } }
    );
    if (response.data.success) {
      notes.value = response.data.data;
    }
  } catch (error) {
    console.error('获取笔记失败:', error);
  } finally {
    loading.value = false;
  }
};

const goToNoteDetail = (noteId) => {
  router.push({ name: 'NoteDetail', params: { id: noteId, userId: route.params.userId } });
};

onMounted(async () => {
  await fetchUserInfo();
  await fetchUserStats();
  await checkFollowStatus();
  await fetchUserNotes();
});
</script>

<style scoped>
.user-profile-container {
  padding: 20px;
  background: linear-gradient(to bottom, #f0f4f8, #ffffff);
}

.user-profile-card {
  margin-top: 20px;
  margin-bottom: 20px;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  background: #ffffff;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 20px;
}

.user-avatar {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  overflow: hidden;
}

.user-details {
  flex: 1;
}

.user-name {
  font-size: 1.8em;
  color: #333;
  margin-bottom: 10px;
}

.user-introduction {
  color: #666;
  margin-bottom: 15px;
}

.user-stats .el-tag {
  margin-right: 10px;
  margin-bottom: 10px;
}

.notes-container {
  margin-top: 20px;
}

.notes-scroll-wrapper {
  overflow-x: auto;
  white-space: nowrap;
  padding: 10px;
}

.notes-scroll {
  display: flex;
  gap: 10px;
}

.note-card {
  flex: 0 0 auto;
  width: 240px;
  transition: transform 0.2s, box-shadow 0.2s;
  cursor: pointer;
}

.note-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

.note-image {
  width: 100%;
  height: 150px;
  object-fit: cover;
  border-radius: 8px;
}

.note-info {
  padding: 10px;
}

.note-title {
  font-size: 1.2em;
  color: #333;
  margin-bottom: 8px;
}

.note-content {
  color: #666;
  margin-bottom: 8px;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
}

.note-date {
  display: flex;
  align-items: center;
  color: #999;
  font-size: 0.9em;
}

.pagination {
  text-align: center;
  margin-top: 20px;
}

.additional-section {
  margin-top: 30px;
  background: #f9f9f9;
  padding: 20px;
  border-radius: 12px;
}

.recommended-users {
  display: flex;
  gap: 20px;
  overflow-x: auto;
  padding: 10px;
}

.recommended-user {
  flex: 0 0 auto;
  width: 120px;
  text-align: center;
}

.recommended-avatar {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  margin-bottom: 10px;
}

.recommended-info {
  font-size: 0.9em;
  color: #555;
}

.activity-feed {
  margin-top: 30px;
  background: #fff;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.activity-feed ul {
  list-style: none;
  padding: 0;
}

.activity-item {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 10px;
  color: #333;
}
</style>