<template>
  <div class="club-detail">
    <el-card v-loading="loading">
      <!-- 俱乐部基本信息 -->
      <div class="club-info">
        <h2>{{ clubInfo.name }}</h2>
        <p class="description">{{ clubInfo.description }}</p>
        <div class="meta-info">
          <span>创建时间: {{ clubInfo.createTime }}</span>
        </div>
      </div>

      <!-- 操作按钮 -->
      <div class="actions" v-if="isHost">
        <el-button type="primary" @click="showEditDialog">编辑信息</el-button>
        <el-button @click="goToManage">管理俱乐部</el-button>
        <el-button @click="goToActivity">活动管理</el-button>
      </div>

      <!-- 成员列表 -->
      <div class="members-section">
        <div class="section-header">
          <h3>俱乐部成员</h3>
          <el-button v-if="isHost" @click="showMemberManage">成员管理</el-button>
        </div>
        
        <el-table :data="members" size="small">
          <el-table-column prop="nickname" label="昵称" />
          <el-table-column prop="joinTime" label="加入时间" />
          <el-table-column label="操作" v-if="isHost">
            <template #default="{ row }">
              <el-button link type="danger" @click="handleRemoveMember(row.userId)">
                移除
              </el-button>
            </template>
          </el-table-column>
        </el-table>

        <el-pagination
          v-model:current-page="memberPage"
          v-model:page-size="memberSize"
          :total="memberTotal"
          @current-change="loadMembers"
        />
      </div>
    </el-card>

    <!-- 编辑俱乐部信息对话框 -->
    <el-dialog v-model="editDialogVisible" title="编辑俱乐部信息">
      <el-form :model="editForm" ref="editFormRef">
        <el-form-item label="名称" prop="name">
          <el-input v-model="editForm.name" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input type="textarea" v-model="editForm.description" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="editDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleEdit">确定</el-button>
      </template>
    </el-dialog>

    <!-- 成员管理对话框 -->
    <el-dialog v-model="memberManageVisible" title="成员管理">
      <el-tabs v-model="manageActiveTab">
        <!-- 加入申请 tab -->
        <el-tab-pane label="加入申请" name="requests">
          <el-table :data="joinRequests" v-loading="requestsLoading">
            <el-table-column prop="username" label="用户名" />
            <el-table-column prop="requestTime" label="申请时间" />
            <el-table-column label="操作">
              <template #default="{ row }">
                <el-button link type="primary" @click="handleReviewJoin(row.userId, 1)">
                  同意
                </el-button>
                <el-button link type="danger" @click="handleReviewJoin(row.userId, 2)">
                  拒绝
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        
        <!-- 主持人管理 tab -->
        <el-tab-pane label="主持人管理" name="hosts">
          <div class="host-manage">
            <el-button type="primary" @click="showAddHostDialog">添加主持人</el-button>
            <el-table :data="hostList" v-loading="hostsLoading">
              <el-table-column prop="nickname" label="昵称" />
              <el-table-column label="操作">
                <template #default="{ row }">
                  <el-button 
                    link 
                    type="danger" 
                    @click="handleRemoveHost(row.userId)"
                  >
                    移除主持人
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-tab-pane>
      </el-tabs>
    </el-dialog>

    <!-- 添加主持人对话框 -->
    <el-dialog v-model="addHostDialogVisible" title="添加主持人">
      <el-form :model="addHostForm">
        <el-form-item label="用户ID">
          <el-input v-model="addHostForm.userId" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="addHostDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleAddHost">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { clubAPI } from '@/api/club'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()
const clubId = route.params.id

const loading = ref(false)
const clubInfo = ref({})
const isHost = ref(false)

// 成员列表相关
const members = ref([])
const memberPage = ref(1)
const memberSize = ref(10)
const memberTotal = ref(0)

// 对话框控制
const editDialogVisible = ref(false)
const memberManageVisible = ref(false)
const editForm = ref({
  name: '',
  description: ''
})

// 加入申请列表
const joinRequests = ref([])
const hostList = ref([])

// 新增状态
const manageActiveTab = ref('requests')
const requestsLoading = ref(false)
const hostsLoading = ref(false)
const addHostDialogVisible = ref(false)
const addHostForm = ref({ userId: '' })

// 加载俱乐部详情
const loadClubDetails = async () => {
  loading.value = true
  try {
    const res = await clubAPI.getClubDetails({ clubId })
    clubInfo.value = res.data
    // 检查当前用户是否是主持人
    const hostRes = await clubAPI.getHostList({ clubId })
    isHost.value = hostRes.data.some(host => host.userId === currentUserId) // 需要从用户store获取currentUserId
  } catch (error) {
    ElMessage.error('获取俱乐部详情失败')
  }
  loading.value = false
}

// 加载成员列表
const loadMembers = async () => {
  try {
    const res = await clubAPI.getClubMembers({
      clubId,
      page: memberPage.value,
      size: memberSize.value
    })
    members.value = res.data
    memberTotal.value = res.total
  } catch (error) {
    ElMessage.error('获取成员列表失败')
  }
}

// 加载加入申请列表
const loadJoinRequests = async () => {
  try {
    const res = await clubAPI.getClubJoinRequests({
      clubId,
      page: 1,
      size: 100
    })
    joinRequests.value = res.data
  } catch (error) {
    ElMessage.error('获取申请列表失败')
  }
}

// 加载主持人列表
const loadHostList = async () => {
  try {
    const res = await clubAPI.getHostList({ clubId })
    hostList.value = res.data
  } catch (error) {
    ElMessage.error('获取主持人列表失败')
  }
}

// 处理编辑俱乐部信息
const handleEdit = async () => {
  try {
    await clubAPI.updateClub({
      clubId,
      ...editForm.value
    })
    ElMessage.success('更新成功')
    editDialogVisible.value = false
    loadClubDetails()
  } catch (error) {
    ElMessage.error('更新失败')
  }
}

// 处理移除成员
const handleRemoveMember = async (userId) => {
  try {
    await clubAPI.removeMember({
      clubId,
      userId
    })
    ElMessage.success('移除成功')
    loadMembers()
  } catch (error) {
    ElMessage.error('移除失败')
  }
}

// 处理加入申请审核
const handleReviewJoin = async (userId, status) => {
  try {
    await clubAPI.reviewJoinRequest({
      clubId,
      userId,
      status
    })
    ElMessage.success('处理成功')
    loadJoinRequests()
  } catch (error) {
    ElMessage.error('处理失败')
  }
}

// 处理移除主持人
const handleRemoveHost = async (userId) => {
  try {
    await clubAPI.removeHost({
      clubId,
      userId
    })
    ElMessage.success('移除成功')
    loadHostList()
  } catch (error) {
    ElMessage.error('移除失败')
  }
}

// 页面跳转
const goToManage = () => {
  router.push(`/club/manage/${clubId}`)
}

const goToActivity = () => {
  router.push(`/club/activity/${clubId}`)
}

// 新增方法
const handleAddHost = async () => {
  try {
    await addSecondHostService({
      clubId: clubId,
      userId: addHostForm.value.userId
    })
    ElMessage.success('添加成功')
    addHostDialogVisible.value = false
    loadHostList()
  } catch (error) {
    ElMessage.error('添加失败')
  }
}

const showAddHostDialog = () => {
  addHostForm.value.userId = ''
  addHostDialogVisible.value = true
}

// 在 watch 中监听 manageActiveTab 变化
watch(manageActiveTab, (newVal) => {
  if (newVal === 'requests') {
    loadJoinRequests()
  } else if (newVal === 'hosts') {
    loadHostList()
  }
})

onMounted(() => {
  loadClubDetails()
  loadMembers()
})
</script>

<style scoped>
.club-detail {
  padding: 20px;
}

.club-info {
  margin-bottom: 20px;
}

.description {
  color: #666;
  margin: 10px 0;
}

.meta-info {
  color: #999;
  font-size: 14px;
}

.actions {
  margin: 20px 0;
}

.members-section {
  margin-top: 20px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.host-manage {
  margin-top: 15px;
}
</style> 