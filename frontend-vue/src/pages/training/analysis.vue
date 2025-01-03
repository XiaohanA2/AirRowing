<template>
  <div class="common-container">
    <!-- 顶部统计卡片 -->
    <div class="statistics-cards">
      <el-row :gutter="20">
        <el-col :span="6" v-for="(stat, index) in statistics" :key="index">
          <el-card shadow="hover" class="stat-card">
            <template #header>
              <div class="stat-header">
                <el-icon>
                  <component :is="stat.icon" />
                </el-icon>
                <span>{{ stat.title }}</span>
              </div>
            </template>
            <div class="stat-value">{{ stat.value }}</div>
            <div class="stat-change" :class="stat.trend">
              {{ stat.change }}
              <el-icon>
                <component :is="stat.trend === 'up' ? 'ArrowUp' : 'ArrowDown'" />
              </el-icon>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 主要内容区域 -->
    <div class="main-content">
      <el-row :gutter="20">
        <!-- 左侧训练历史和图表 -->
        <el-col :span="16">
          <el-card class="chart-card">
            <template #header>
              <div class="card-header">
                <span>训练趋势分析</span>
                <div class="chart-controls">
                  <el-radio-group v-model="chartTimeRange" size="small">
                    <el-radio-button label="week">周</el-radio-button>
                    <el-radio-button label="month">月</el-radio-button>
                    <el-radio-button label="year">年</el-radio-button>
                  </el-radio-group>
                </div>
              </div>
            </template>
            <div class="chart-container">
              <!-- 这里放置图表组件 -->
            </div>
          </el-card>

          <el-card class="history-card">
            <template #header>
              <div class="card-header">
                <span>训练记录</span>
                <div class="header-controls">
                  <el-select 
                    v-model="currentTrainingType" 
                    placeholder="选择训练类型"
                    style="margin-right: 10px"
                    @change="refreshHistory"
                  >
                    <el-option label="全部类型" value="all" />
                    <el-option label="赛艇训练" value="rowing" />
                    <el-option label="游泳训练" value="swimming" />
                    <el-option label="跑步训练" value="running" />
                    <el-option label="力量训练" value="strength" />
                    <el-option label="有氧训练" value="cardio" />
                  </el-select>
                  <el-button type="primary" @click="showUploadDialog">
                    上传训练
                  </el-button>
                  <el-button @click="refreshHistory">
                    <el-icon><Refresh /></el-icon>
                  </el-button>
                </div>
              </div>
            </template>
            <el-table :data="trainingHistory" style="width: 100%">
              <el-table-column prop="trainingDate" label="日期" width="180">
                <template #default="scope">
                  {{ formatDate(scope.row.trainingDate) }}
                </template>
              </el-table-column>
              <el-table-column prop="duration" label="时长(分钟)" width="120" />
              <el-table-column prop="distance" label="距离(km)" width="120">
                <template #default="scope">
                  {{ scope.row.distance?.toFixed(2) }}
                </template>
              </el-table-column>
              <el-table-column prop="calories" label="卡路里" width="120">
                <template #default="scope">
                  {{ scope.row.calories?.toFixed(1) }}
                </template>
              </el-table-column>
              <el-table-column prop="type" label="训练类型" width="120">
                <template #default="scope">
                  {{ getTrainingTypeName(scope.row.type) }}
                </template>
              </el-table-column>
              <el-table-column label="操作" width="220">
                <template #default="scope">
                  <el-button size="small" @click="showTrainingDetail(scope.row)">
                    详情
                  </el-button>
                  <el-button size="small" type="primary" @click="handleEditTraining(scope.row)">
                    编辑
                  </el-button>
                  <el-button size="small" type="danger" @click="handleDeleteTraining(scope.row.id)">
                    删除
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </el-card>
        </el-col>

        <!-- 右侧AI助手 -->
        <el-col :span="8">
          <el-card class="ai-assistant-card">
            <template #header>
              <div class="card-header">
                <span>AI 训练助手</span>
                <el-button type="text" @click="clearChat">清空对话</el-button>
              </div>
            </template>
            <div class="chat-container">
              <el-scrollbar height="600px" ref="chatScrollbar">
                <div class="chat-messages">
                  <div v-for="(msg, index) in chatMessages" :key="index" 
                       :class="['message', msg.type]">
                    <div class="message-content">
                      <template v-if="msg.mediaType">
                        <div class="media-content">
                          <img v-if="msg.mediaType === 'image'" :src="msg.mediaUrl" class="message-image"/>
                          <video v-if="msg.mediaType === 'video'" :src="msg.mediaUrl" controls class="message-video"></video>
                        </div>
                      </template>
                      {{ msg.content }}
                    </div>
                    <div class="message-time">{{ msg.time }}</div>
                  </div>
                  <div v-if="isLoading" class="message ai loading-message">
                    <div class="typing-indicator">
                      <span></span>
                      <span></span>
                      <span></span>
                    </div>
                  </div>
                </div>
              </el-scrollbar>
              <div class="chat-input">
                <el-upload
                  class="media-upload"
                  :show-file-list="false"
                  :before-upload="handleUpload"
                  accept="image/*,video/*"
                >
                  <el-button class="upload-btn" type="primary" plain>
                    <el-icon><PictureRounded /></el-icon>
                    上传图片/视频
                  </el-button>
                </el-upload>
                <div class="input-wrapper">
                  <el-input v-model="chatInput" placeholder="请输入您的问题" 
                           @keyup.enter="sendMessage">
                    <template #append>
                      <el-button type="primary" @click="sendMessage" :loading="isLoading">发送</el-button>
                    </template>
                  </el-input>
                </div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 上传训练记录弹窗 -->
    <el-dialog 
      :title="selectedTraining ? '编辑训练记录' : '新增训练记录'" 
      v-model="uploadDialogVisible" 
      width="500px"
    >
      <el-form 
        ref="formRef"
        :model="uploadForm" 
        label-width="100px" 
        :rules="formRules"
      >
        <el-form-item label="训练类型" prop="type">
          <el-select v-model="uploadForm.type" placeholder="请选择训练类型">
            <el-option label="赛艇训练" value="rowing" />
            <el-option label="力量训练" value="strength" />
            <el-option label="有氧训练" value="cardio" />
          </el-select>
        </el-form-item>
        <el-form-item label="训练日期" prop="trainingDate">
          <el-date-picker
            v-model="uploadForm.trainingDate"
            type="datetime"
            placeholder="选择训练日期时间"
            format="YYYY-MM-DD HH:mm"
            value-format="YYYY-MM-DD HH:mm:ss"
          />
        </el-form-item>
        <el-form-item label="训练时长" prop="duration">
          <el-input-number v-model="uploadForm.duration" :min="1" :max="999" />
          <span class="unit-label">分钟</span>
        </el-form-item>
        <el-form-item label="训练距离" prop="distance">
          <el-input-number v-model="uploadForm.distance" :min="0" :precision="1" :step="0.1" />
          <span class="unit-label">公里</span>
        </el-form-item>
        <el-form-item label="消耗卡路里" prop="calories">
          <el-input-number v-model="uploadForm.calories" :min="0" />
          <span class="unit-label">卡路里</span>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="uploadDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSubmitTraining">确认</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 训练详情弹窗 -->
    <el-dialog v-model="detailDialogVisible" title="训练详情" width="80%">
      <div class="training-detail">
        <!-- 训练详情内容 -->
      </div>
    </el-dialog>

    <!-- 添加分页组件 -->
    <div class="pagination-container">
      <el-pagination
        v-model:current-page="currentPage"
        :page-size="pageSize"
        :total="totalRecords"
        @current-change="handlePageChange"
        layout="prev, pager, next"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { 
    submitTrainingRecord, 
    queryTrainingRecords, 
    getTrainingStatistics,
    updateTrainingRecord,
    deleteTrainingRecord 
} from '@/api/training_record'
import axios from 'axios'
import { PictureRounded, Plus } from '@element-plus/icons-vue'

// 获取用户状态
const userStore = useUserStore()

// 训练历史记录
const trainingHistory = ref([])
const uploadForm = ref({
  type: 'rowing',
  trainingDate: new Date().toISOString().slice(0, 19).replace('T', ' '),
  duration: 30,
  distance: 5.0,
  calories: null
})
const chatMessages = ref([])
const chatInput = ref('')
const analysisContent = ref('')
const chatScrollbar = ref(null)
const isLoading = ref(false)

// 新增的状态变量
const uploadDialogVisible = ref(false)
const detailDialogVisible = ref(false)
const chartTimeRange = ref('week')
const statistics = ref([])
const currentPage = ref(1)
const pageSize = ref(10)
const totalRecords = ref(0)
const selectedTraining = ref(null)
const formRef = ref(null)
const currentTrainingType = ref('all')  // 默认显示所有类型

// 获取统计数据
const fetchStatistics = async () => {
  try {
    const startDate = new Date()
    startDate.setDate(startDate.getDate() - 7) // 获取最近7天的数据
    
    const queryParams = {
      startDate: startDate.toISOString().split('T')[0],
      endDate: new Date().toISOString().split('T')[0]
    }

    // 只有当选择了特定类型时才添加 type 参数
    if (currentTrainingType.value !== 'all') {
      queryParams.type = currentTrainingType.value
    }
    
    const res = await getTrainingStatistics(queryParams)

    if (res.success && res.data) {
      const stats = res.data
      statistics.value = [
        {
          title: '本周训练次数',
          value: `${stats.totalSessions || 0}次`,
          change: `较上周 ${stats.sessionChange > 0 ? '+' : ''}${stats.sessionChange || 0}%`,
          trend: (stats.sessionChange || 0) >= 0 ? 'up' : 'down',
          icon: 'Calendar'
        },
        {
          title: '总训练时长',
          value: `${Math.floor((stats.totalDuration || 0) / 60)}小时${(stats.totalDuration || 0) % 60}分`,
          change: `较上周 ${stats.durationChange > 0 ? '+' : ''}${stats.durationChange || 0}%`,
          trend: (stats.durationChange || 0) >= 0 ? 'up' : 'down',
          icon: 'Timer'
        },
        {
          title: '总训练距离',
          value: `${(stats.totalDistance || 0).toFixed(1)}km`,
          change: `较上周 ${stats.distanceChange > 0 ? '+' : ''}${stats.distanceChange || 0}%`,
          trend: (stats.distanceChange || 0) >= 0 ? 'up' : 'down',
          icon: 'Position'
        },
        {
          title: '平均配速',
          value: stats.averagePace ? `${stats.averagePace}/500m` : '-',
          change: stats.paceChange ? `较上周 ${stats.paceChange}秒` : '-',
          trend: (stats.paceChange || 0) <= 0 ? 'up' : 'down',
          icon: 'SpeedMeter'
        }
      ]
    }
  } catch (error) {
    console.error('获取统计数据失败:', error)
    ElMessage.error('获取统计数据失败')
  }
}

// 获取训练历史记录
const refreshHistory = async () => {
  try {
    const queryParams = {
      page: currentPage.value,
      size: pageSize.value,
      startDate: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
      endDate: new Date().toISOString().split('T')[0]
    }
    
    // 只有当选择了特定类型时才添加 type 参数
    if (currentTrainingType.value !== 'all') {
      queryParams.type = currentTrainingType.value
    }

    const res = await queryTrainingRecords(queryParams)
    
    if (res.success && res.data) {
      const list = res.data.list || []
      trainingHistory.value = list.map(record => ({
        ...record,
        trainingDate: record.trainingDate || new Date().toISOString(),
        duration: Number(record.duration) || 0,
        distance: Number(record.distance) || 0,
        calories: Number(record.calories) || 0
      }))
      totalRecords.value = res.data.total || list.length
      
      // 如果没有数据，显示提示
      if (list.length === 0) {
        ElMessage.info('暂无训练记录')
      }
    } else {
      trainingHistory.value = []
      totalRecords.value = 0
      ElMessage.warning(res.message || '暂无训练记录')
    }
  } catch (error) {
    console.error('获取历史记录失败:', error)
    ElMessage.error(error.message || '获取历史记录失败')
    trainingHistory.value = []
    totalRecords.value = 0
  }
}

// 处理分页变化
const handlePageChange = (page) => {
  currentPage.value = page
  refreshHistory()
}

// 提交训练记录
const handleSubmitTraining = async () => {
  try {
    if (!formRef.value) return
    await formRef.value.validate()

    const trainingData = {
      ...uploadForm.value,
      status: 1,
      type: uploadForm.value.type || 'rowing'
    }

    let res
    if (selectedTraining.value) {
      res = await updateTrainingRecord({
        id: selectedTraining.value.id,
        ...trainingData
      })
    } else {
      res = await submitTrainingRecord(trainingData)
    }

    if (res && (res.success || typeof res === 'string')) {
      ElMessage.success(selectedTraining.value ? '更新成功' : '添加成功')
      uploadDialogVisible.value = false
      // 重置表单
      uploadForm.value = {
        type: 'rowing',
        trainingDate: new Date().toISOString().slice(0, 19).replace('T', ' '),
        duration: 30,
        distance: 5.0,
        calories: null
      }
      formRef.value.resetFields()
      selectedTraining.value = null
      currentTrainingType.value = 'all'  // 重置训练类型筛选
      await refreshHistory()
      await fetchStatistics()
    } else {
      throw new Error(res?.message || (selectedTraining.value ? '更新失败' : '添加失败'))
    }
  } catch (error) {
    console.error('提交训练记录失败:', error)
    ElMessage.error(error.message || '提交失败')
  }
}

// 发送聊天消息
const sendMessage = async () => {
  if (!chatInput.value.trim() || isLoading.value) return

  const newMessage = {
    content: chatInput.value,
    type: 'user',
    time: new Date().toLocaleTimeString()
  }
  chatMessages.value.push(newMessage)
  
  // 清空输入框
  const userQuestion = chatInput.value
  chatInput.value = ''
  
  try {
    isLoading.value = true
    const response = await axios.post('/ai/chat', {
      user_id: userStore.userInfo.id,
      question: userQuestion
    })

    if (response.data.success) {
      chatMessages.value.push({
        content: response.data.data,
        type: 'ai',
        time: new Date().toLocaleTimeString()
      })
      scrollToBottom()
    } else {
      ElMessage.error(response.data.message || '发送消息失败')
    }
  } catch (error) {
    console.error('发送消息失败:', error)
    ElMessage.error('发送消息失败，请稍后重试')
  } finally {
    isLoading.value = false
  }
}

// 滚动到底部
const scrollToBottom = () => {
  setTimeout(() => {
    const scrollbar = chatScrollbar.value
    if (scrollbar) {
      scrollbar.setScrollTop(scrollbar.wrapRef.scrollHeight)
    }
  }, 100)
}

// 清空聊天记录
const clearChat = () => {
  chatMessages.value = []
}

// 刷新分析报告
const refreshAnalysis = async () => {
  try {
    const res = await getTrainingStatistics({
        type: 'rowing',
        startDate: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],  // 最近7天
        endDate: new Date().toISOString().split('T')[0]
    })
    
    if (res.success && res.data) {
        // 使用实际的统计数据生成报告
        // ... 处理统计数据的逻辑
    } else {
        analysisContent.value = `
            <h3>本周训练分析报告</h3>
            <p>您本周共完成5次训练，总距离26.5公里，平均配速2:05。相比上周：</p>
            <ul>
              <li>训练频次增加1次</li>
              <li>总距离提升15%</li>
              <li>平均配速提升3秒</li>
            </ul>
            <h4>技术分析</h4>
            <p>根据您的训练数据，我们发现：</p>
            <ul>
              <li>起划阶段发力更加平稳</li>
              <li>收放比例保持在1:2左右，符合标准要求</li>
              <li>长距离训练中后半程配速波动减小</li>
            </ul>
            <h4>建议</h4>
            <ol>
              <li>可以适当增加高强度间歇训练的比例</li>
              <li>建议每周安排1-2次专门的技术训练</li>
              <li>注意恢复训练的质量，避免过度疲劳</li>
            </ol>
        `
    }
  } catch (error) {
    ElMessage.error('获取分析报告失败')
  }
}

// 添加训练类型名称映射函数
const getTrainingTypeName = (type) => {
  const typeMap = {
    'rowing': '赛艇',
    'swimming': '游泳',
    'running': '跑步',
    'cycling': '骑行',
    'strength': '力量',
    'cardio': '有氧'
  }
  return typeMap[type] || type
}

// 修改日期格式化函数
const formatDate = (dateString) => {
  if (!dateString) return ''
  try {
    const date = new Date(dateString)
    if (isNaN(date.getTime())) return dateString
    
    return date.toLocaleString('zh-CN', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit'
    })
  } catch (error) {
    console.error('日期格式化错误:', error)
    return dateString
  }
}

// 显示上传对话框
const showUploadDialog = () => {
  uploadDialogVisible.value = true
}

// 显示训练详情
const showTrainingDetail = (training) => {
  detailDialogVisible.value = true
  // 加载训练详情数据
}

// 分析特定训练
const analyzeTraining = (training) => {
  // 实现训练分析逻辑
}

// 修改训练记录
const handleEditTraining = (training) => {
  selectedTraining.value = { ...training }
  uploadForm.value = {
    type: training.type || 'rowing',
    // 确保日期格式正确
    trainingDate: training.trainingDate 
      ? new Date(training.trainingDate).toISOString().slice(0, 19).replace('T', ' ')
      : new Date().toISOString().slice(0, 19).replace('T', ' '),
    duration: training.duration || 30,
    distance: training.distance || 5.0,
    calories: training.calories || null
  }
  // 重置表单验证状态
  nextTick(() => {
    formRef.value?.clearValidate()
  })
  uploadDialogVisible.value = true
}

// 删除训练记录
const handleDeleteTraining = async (id) => {
  try {
    await ElMessageBox.confirm('确定要删除这条训练记录吗？', '提示', {
      type: 'warning',
      confirmButtonText: '确定',
      cancelButtonText: '取消'
    })
    
    const res = await deleteTrainingRecord(id)
    if (!res) {
      throw new Error('服务器响应为空')
    }

    if (res.success) {
      ElMessage.success('删除成功')
      await refreshHistory()
      await fetchStatistics()
    } else {
      throw new Error(res.message || '删除失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除训练记录失败:', error)
      ElMessage.error(error.message || '删除失败')
    }
  }
}

// 添加表单验证规则
const formRules = {
  type: [{ required: true, message: '请选择训练类型', trigger: 'change' }],
  trainingDate: [{ required: true, message: '请选择训练日期', trigger: 'change' }],
  duration: [{ required: true, message: '请输入训练时长', trigger: 'blur' }],
  distance: [{ required: true, message: '请输入训练距离', trigger: 'blur' }]
}

// 在对话框关闭时重置表单
const handleDialogClose = () => {
  formRef.value?.resetFields()
  selectedTraining.value = null
}

// 处理文件上传
const handleUpload = async (file) => {
  try {
    // 检查文件类型和大小
    const isImage = file.type.startsWith('image/')
    const isVideo = file.type.startsWith('video/')
    const maxSize = 10 * 1024 * 1024 // 10MB

    if (!isImage && !isVideo) {
      ElMessage.error('只支持图片或视频文件')
      return false
    }

    if (file.size > maxSize) {
      ElMessage.error('文件大小不能超过10MB')
      return false
    }

    // 创建 FormData
    const formData = new FormData()
    formData.append('file', file)
    formData.append('user_id', userStore.userInfo.id)

    // 显示上传中的消息
    const tempMessage = {
      content: `正在上传${isImage ? '图片' : '视频'}...`,
      type: 'user',
      time: new Date().toLocaleTimeString()
    }
    chatMessages.value.push(tempMessage)

    // 调用上传 API（需要自行实现）
    const response = await axios.post('/api/upload', formData)

    if (response.data.success) {
      // 更新消息内容，显示上传的媒体文件
      chatMessages.value.pop() // 移除临时消息
      chatMessages.value.push({
        content: '',
        type: 'user',
        time: new Date().toLocaleTimeString(),
        mediaType: isImage ? 'image' : 'video',
        mediaUrl: response.data.url
      })
      scrollToBottom()
    } else {
      throw new Error(response.data.message || '上传失败')
    }
  } catch (error) {
    console.error('上传失败:', error)
    ElMessage.error('上传失败，请重试')
  }
  return false // 阻止默认上传行为
}

onMounted(() => {
  refreshHistory()
  refreshAnalysis()
  // 添加初始AI欢迎消息
  chatMessages.value = [
    {
      content: "你好！我是你的AI训练助手。我可以帮你分析训练数据，提供专业建议。有什么我可以帮你的吗？",
      type: "ai",
      time: new Date().toLocaleTimeString()
    }
  ]
})
</script>

<style scoped>
.common-container {
  padding: 20px;
  background-color: #f5f7fa;
}

.statistics-cards {
  margin-bottom: 20px;
}

.stat-card {
  .stat-header {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .stat-value {
    font-size: 24px;
    font-weight: bold;
    margin: 10px 0;
  }

  .stat-change {
    font-size: 14px;
    display: flex;
    align-items: center;
    gap: 4px;

    &.up {
      color: #67c23a;
    }

    &.down {
      color: #f56c6c;
    }
  }
}

.main-content {
  margin-top: 20px;
}

.chart-card {
  margin-bottom: 20px;
  
  .chart-container {
    height: 400px;
  }
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.chat-container {
  height: 650px;
  display: flex;
  flex-direction: column;
}

.message {
  margin: 10px;
  padding: 10px;
  border-radius: 8px;
  max-width: 80%;

  &.user {
    background-color: #e8f5fe;
    margin-left: auto;
  }

  &.ai {
    background-color: #f4f4f5;
    margin-right: auto;
  }
}

.chat-input {
  margin-top: auto;
  padding: 10px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.media-upload {
  display: flex;
  justify-content: center;
}

.upload-btn {
  width: 140px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
}

.input-wrapper {
  width: 100%;
}

/* 确保图标垂直居中 */
.upload-btn .el-icon {
  margin-right: 4px;
  font-size: 16px;
}

/* 添加响应式设计 */
@media (max-width: 1200px) {
  .el-col {
    width: 100% !important;
  }
}

/* 在 style 中添加分页样式 */
.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}

/* 添加表单相关样式 */
.unit-label {
  margin-left: 8px;
  color: #666;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.loading-message {
  padding: 15px;
}

.typing-indicator {
  display: flex;
  gap: 5px;
}

.typing-indicator span {
  width: 8px;
  height: 8px;
  background-color: #90939975;
  border-radius: 50%;
  animation: bounce 1.4s infinite ease-in-out;
}

.typing-indicator span:nth-child(1) { animation-delay: -0.32s; }
.typing-indicator span:nth-child(2) { animation-delay: -0.16s; }

@keyframes bounce {
  0%, 80%, 100% { transform: scale(0); }
  40% { transform: scale(1); }
}

.upload-inline {
  display: inline-block;
  margin-right: 4px;
}

.message-image {
  max-width: 200px;
  max-height: 200px;
  border-radius: 4px;
  margin: 5px 0;
}

.message-video {
  max-width: 300px;
  max-height: 200px;
  border-radius: 4px;
  margin: 5px 0;
}

.media-content {
  margin-bottom: 8px;
}
</style>