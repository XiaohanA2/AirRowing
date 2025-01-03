<template>
  <div class="club-list">
    <div class="header">
      <el-button type="primary" @click="showCreateDialog">创建俱乐部</el-button>
    </div>
    
    <el-table :data="clubList" v-loading="loading">
      <el-table-column prop="name" label="俱乐部名称" />
      <el-table-column prop="description" label="描述" />
      <el-table-column prop="createTime" label="创建时间" />
      <el-table-column label="操作">
        <template #default="{ row }">
          <el-button link @click="goToDetail(row.clubId)">查看</el-button>
          <el-button link @click="handleJoin(row.clubId)">申请加入</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <el-pagination
      v-model:current-page="page"
      v-model:page-size="size"
      :total="total"
      @current-change="loadClubs"
    />
    
    <!-- 创建俱乐部对话框 -->
    <el-dialog v-model="createDialogVisible" title="创建俱乐部">
      <el-form :model="createForm" ref="createFormRef">
        <el-form-item label="名称" prop="name">
          <el-input v-model="createForm.name" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input type="textarea" v-model="createForm.description" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="createDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleCreate">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { 
  createClubService, 
  getClubListService, 
  joinClubService 
} from '@/api/club'
import { ElMessage } from 'element-plus'

const router = useRouter()
const loading = ref(false)
const clubList = ref([])
const page = ref(1)
const size = ref(10)
const total = ref(0)

const createDialogVisible = ref(false)
const createForm = ref({
  name: '',
  description: ''
})

const loadClubs = async () => {
  loading.value = true
  try {
    const res = await getClubListService({
      page: page.value,
      size: size.value
    })
    clubList.value = res.data?.clubs || []
    total.value = res.data?.total || 0
  } catch (error) {
    ElMessage.error('获取俱乐部列表失败')
  } finally {
    loading.value = false
  }
}

const handleCreate = async () => {
  try {
    await createClubService(createForm.value)
    ElMessage.success('创建成功')
    createDialogVisible.value = false
    createForm.value = { name: '', description: '' }  // 清空表单
    loadClubs()  // 重新加载列表
  } catch (error) {
    ElMessage.error('创建失败')
  }
}

const handleJoin = async (clubId) => {
  try {
    await joinClubService({ clubId })
    ElMessage.success('申请已提交')
  } catch (error) {
    ElMessage.error('申请失败')
  }
}

const goToDetail = (clubId) => {
  router.push(`/main/club/detail/${clubId}`)
}

const showCreateDialog = () => {
  createForm.value = { name: '', description: '' }  // 清空表单
  createDialogVisible.value = true
}

onMounted(() => {
  loadClubs()
})
</script>

<style scoped>
.club-list {
  padding: 20px;
}

.header {
  margin-bottom: 20px;
}

.el-pagination {
  margin-top: 20px;
  justify-content: flex-end;
}
</style> 