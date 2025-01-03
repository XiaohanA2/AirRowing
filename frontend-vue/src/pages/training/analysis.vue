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
                  <el-select 
                    v-model="trendTrainingType" 
                    placeholder="选择训练类型"
                    style="width: 120px; margin-right: 10px"
                    @change="handleTrendFilterChange"
                  >
                    <el-option label="赛艇训练" value="赛艇训练" />
                    <el-option label="力量训练" value="力量训练" />
                    <el-option label="有氧训练" value="有氧训练" />
                  </el-select>
                  <el-date-picker
                    v-model="trendDateRange"
                    type="daterange"
                    range-separator="至"
                    start-placeholder="开始日期"
                    end-placeholder="结束日期"
                    format="YYYY-MM-DD"
                    value-format="YYYY-MM-DD"
                    style="width: 240px;"
                    @change="handleTrendFilterChange"
                  />
                </div>
              </div>
            </template>
            <div class="chart-container">
              <div class="trend-statistics">
                <el-row :gutter="20">
                  <el-col :span="8">
                    <div class="stat-item">
                      <div class="stat-label">平均训练时长</div>
                      <div class="stat-value">{{ formatDuration(trendStats.avgDuration || 0) }}</div>
                    </div>
                  </el-col>
                  <el-col :span="8">
                    <div class="stat-item">
                      <div class="stat-label">平均训练距离</div>
                      <div class="stat-value">{{ (trendStats.avgDistance || 0).toFixed(2) }} km</div>
                    </div>
                  </el-col>
                  <el-col :span="8">
                    <div class="stat-item">
                      <div class="stat-label">平均消耗卡路里</div>
                      <div class="stat-value">{{ (trendStats.avgCalories || 0).toFixed(2) }} kcal</div>
                    </div>
                  </el-col>
                </el-row>
                <el-row :gutter="20" style="margin-top: 20px;">
                  <el-col :span="8">
                    <div class="stat-item">
                      <div class="stat-label">总训练时长</div>
                      <div class="stat-value">{{ formatDuration(trendStats.totalDuration || 0) }}</div>
                    </div>
                  </el-col>
                  <el-col :span="8">
                    <div class="stat-item">
                      <div class="stat-label">总训练距离</div>
                      <div class="stat-value">{{ (trendStats.totalDistance || 0).toFixed(2) }} km</div>
                    </div>
                  </el-col>
                  <el-col :span="8">
                    <div class="stat-item">
                      <div class="stat-label">总消耗卡路里</div>
                      <div class="stat-value">{{ (trendStats.totalCalories || 0).toFixed(2) }} kcal</div>
                    </div>
                  </el-col>
                </el-row>
              </div>

              <!-- 添加图表展示区域 -->
              <div class="charts-section">
                <!-- 训练强度分布图 -->
                <el-row :gutter="20" style="margin-top: 30px;">
                  <el-col :span="12">
                    <div class="chart-wrapper">
                      <div class="chart-title">训练强度分布</div>
                      <div class="chart-subtitle">基于训练时长和距离的分析</div>
                      <div ref="intensityChartRef" style="height: 300px;"></div>
                    </div>
                  </el-col>
                  <el-col :span="12">
                    <div class="chart-wrapper">
                      <div class="chart-title">训练进展趋势</div>
                      <div class="chart-subtitle">距离和配速的变化趋势</div>
                      <div ref="progressChartRef" style="height: 300px;"></div>
                    </div>
                  </el-col>
                </el-row>

                <!-- 训练时间分布和目标完成度 -->
                <el-row :gutter="20" style="margin-top: 20px;">
                  <el-col :span="12">
                    <div class="chart-wrapper">
                      <div class="chart-title">训练时间分布</div>
                      <div class="chart-subtitle">不同时段的训练频率</div>
                      <div ref="timeDistributionChartRef" style="height: 300px;"></div>
                    </div>
                  </el-col>
                  <el-col :span="12">
                    <div class="chart-wrapper">
                      <div class="chart-title">目标完成度</div>
                      <div class="chart-subtitle">与设定目标的对比</div>
                      <div ref="goalCompletionChartRef" style="height: 300px;"></div>
                    </div>
                  </el-col>
                </el-row>

                <!-- 训练数据对比 -->
                <el-row :gutter="20" style="margin-top: 20px;">
                  <el-col :span="24">
                    <div class="chart-wrapper">
                      <div class="chart-title">训练数据周期对比</div>
                      <div class="chart-subtitle">本周期与上个周期的训练数据对比</div>
                      <div ref="comparisonChartRef" style="height: 300px;"></div>
                    </div>
                  </el-col>
                </el-row>
              </div>
            </div>
          </el-card>

          <el-card class="history-card">
            <template #header>
              <div class="card-header">
                <span>训练记录</span>
                <div class="header-controls">
                  <el-date-picker
                    v-model="startDate"
                    type="date"
                    placeholder="开始日期"
                    format="YYYY-MM-DD"
                    value-format="YYYY-MM-DD"
                    :disabled-date="disableStartDate"
                    style="margin-right: 10px; width: 160px"
                    @change="handleDateChange"
                  />
                  <el-date-picker
                    v-model="endDate"
                    type="date"
                    placeholder="结束日期"
                    format="YYYY-MM-DD"
                    value-format="YYYY-MM-DD"
                    :disabled-date="disableEndDate"
                    style="margin-right: 10px; width: 160px"
                    @change="handleDateChange"
                  />
                  <el-select 
                    v-model="currentTrainingType" 
                    placeholder="选择训练类型"
                    style="margin-right: 10px"
                    @change="handleTrainingTypeChange"
                  >
                    <el-option label="全部类型" value="all" />
                    <el-option label="赛艇训练" value="赛艇训练" />
                    <el-option label="力量训练" value="力量训练" />
                    <el-option label="有氧训练" value="有氧训练" />
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
            <el-table :data="trainingHistory" style="width: 100%" v-loading="loading">
              <el-table-column prop="trainingDate" label="日期" width="180">
                <template #default="scope">
                  {{ formatDate(scope.row.trainingDate) }}
                </template>
              </el-table-column>
              <el-table-column prop="duration" label="时长" width="120">
                <template #default="scope">
                  {{ formatDuration(scope.row.duration) }}
                </template>
              </el-table-column>
              <el-table-column prop="distance" label="距离(km)" width="120">
                <template #default="scope">
                  {{ (scope.row.distance || 0).toFixed(2) }}
                </template>
              </el-table-column>
              <el-table-column prop="calories" label="卡路里" width="120">
                <template #default="scope">
                  {{ (scope.row.calories || 0).toFixed(2) }}
                </template>
              </el-table-column>
              <el-table-column prop="type" label="训练类型" width="120">
                <template #default="scope">
                  {{ scope.row.type }}
                </template>
              </el-table-column>
              <el-table-column label="操作" width="100">
                <template #default="scope">
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
            <el-option label="赛艇训练" value="赛艇训练" />
            <el-option label="力量训练" value="力量训练" />
            <el-option label="有氧训练" value="有氧训练" />
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
import { ref, onMounted, nextTick, computed, onUnmounted } from 'vue'
import { ElMessage } from 'element-plus'
import { ElMessageBox } from 'element-plus/es'
import 'element-plus/es/components/base/style/css'
import 'element-plus/es/components/message-box/style/css'
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
import * as echarts from 'echarts/core'
import { PieChart, LineChart, BarChart, RadarChart } from 'echarts/charts'
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
} from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'

// 注册必需的组件
echarts.use([
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent,
  PieChart,
  LineChart,
  BarChart,
  RadarChart,
  CanvasRenderer
])

// 获取用户状态
const userStore = useUserStore()

// 训练历史记录
const trainingHistory = ref([])
const uploadForm = ref({
  type: '赛艇训练',
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
const statistics = ref([])
const currentPage = ref(1)
const pageSize = ref(10)
const totalRecords = ref(0)
const selectedTraining = ref(null)
const formRef = ref(null)
const currentTrainingType = ref('all')  // 默认显示所有类型
const startDate = ref(null)
const endDate = ref(null)
const loading = ref(false)

// 添加趋势统计数据
const trendStats = ref({})

// 添加趋势分析筛选相关的响应式变量
const trendTrainingType = ref('赛艇训练') // 默认选择赛艇训练
const trendDateRange = ref(null)

// 添加图表引用
const intensityChartRef = ref(null)
const progressChartRef = ref(null)
const timeDistributionChartRef = ref(null)
const goalCompletionChartRef = ref(null)
const comparisonChartRef = ref(null)

// 图表实例
let intensityChart = null
let progressChart = null
let timeDistributionChart = null
let goalCompletionChart = null
let comparisonChart = null

// 添加日期验证和处理函数
const disableStartDate = (time) => {
  if (endDate.value) {
    return time.getTime() > new Date(endDate.value).getTime()
  }
  return false
}

const disableEndDate = (time) => {
  if (startDate.value) {
    return time.getTime() < new Date(startDate.value).getTime()
  }
  return false
}

const handleDateChange = () => {
  // 验证日期是否有效
  if (startDate.value && endDate.value) {
    const start = new Date(startDate.value).getTime()
    const end = new Date(endDate.value).getTime()
    
    if (start > end) {
      ElMessage.warning('开始日期不能大于结束日期')
      return
    }
  }
  
  refreshHistory()
}

// 获取统计数据
const fetchStatistics = async () => {
  try {
    const queryParams = {
      type: currentTrainingType.value === 'all' ? undefined : currentTrainingType.value,
      startDate: startDate.value || undefined,
      endDate: endDate.value || undefined
    }
    
    const res = await getTrainingStatistics(queryParams)

    if (res.success && res.data) {
      const stats = res.data
      statistics.value = [
        {
          title: '训练次数',
          value: `${stats.totalSessions || 0}次`,
          change: `较上周 ${stats.sessionChange > 0 ? '+' : ''}${stats.sessionChange || 0}%`,
          trend: (stats.sessionChange || 0) >= 0 ? 'up' : 'down',
          icon: 'Calendar'
        },
        {
          title: '训练时长',
          value: `${Math.floor((stats.totalDuration || 0) / 60)}小时${(stats.totalDuration || 0) % 60}分`,
          change: `较上周 ${stats.durationChange > 0 ? '+' : ''}${stats.durationChange || 0}%`,
          trend: (stats.durationChange || 0) >= 0 ? 'up' : 'down',
          icon: 'Timer'
        },
        {
          title: '训练距离',
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
  loading.value = true
  try {
    const queryParams = {
      page: currentPage.value,
      size: pageSize.value,
      type: currentTrainingType.value === 'all' ? undefined : currentTrainingType.value,
      startDate: startDate.value || undefined,
      endDate: endDate.value || undefined
    }

    console.log('Sending query params:', queryParams)

    const res = await queryTrainingRecords(queryParams)
    console.log('Query response:', res)
    
    if (res && res.data) {
      console.log('Processing training data:', res.data)
      // 将数据按时间倒序排列
      const sortedList = [...res.data.list].sort((a, b) => {
        return new Date(b.trainingDate) - new Date(a.trainingDate)
      })
      
      trainingHistory.value = sortedList.map(record => {
        console.log('Processing record:', record)
        return {
          id: record.id,
          trainingDate: record.trainingDate,
          duration: Number(record.duration || 0),
          distance: Number(record.distance || 0),
          calories: Number(record.calories || 0),
          type: record.type || '未知类型'
        }
      })
      
      totalRecords.value = Number(res.data.total || 0)
      pageSize.value = Number(res.data.size || 10)
      currentPage.value = Number(res.data.page || 1)
      
      console.log('Processed training history:', trainingHistory.value)
      
      if (trainingHistory.value.length === 0) {
        ElMessage.info('暂无训练记录')
      }
    } else {
      console.warn('Invalid response format:', res)
      trainingHistory.value = []
      totalRecords.value = 0
      ElMessage.warning('获取训练记录失败')
    }
  } catch (error) {
    console.error('获取历史记录失败:', error)
    ElMessage.error(error.message || '获取历史记录失败')
    trainingHistory.value = []
    totalRecords.value = 0
  } finally {
    loading.value = false
  }
}

// 处理分页变化
const handlePageChange = async (page) => {
  currentPage.value = page
  await refreshHistory()
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
        type: '赛艇训练',
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
  return type || '未知类型'
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
    }).replace(/\//g, '-')
  } catch (error) {
    console.error('日期格式化错误:', error)
    return dateString
  }
}

// 显示上传对话框
const showUploadDialog = () => {
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
    
    loading.value = true
    const res = await deleteTrainingRecord(id)
    
    if (res.success) {
      ElMessage.success(res.data || '删除成功')
      // 刷新数据
      await refreshHistory()
      await fetchStatistics()
    } else {
      throw new Error(res.message || '删除失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除训练记录失败:', error)
      ElMessage.error(typeof error === 'string' ? error : error.message || '删除失败')
    }
  } finally {
    loading.value = false
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

// 处理趋势分析筛选条件变化
const handleTrendFilterChange = async () => {
  try {
    const params = {
      type: trendTrainingType.value,
      startDate: trendDateRange.value ? trendDateRange.value[0] : undefined,
      endDate: trendDateRange.value ? trendDateRange.value[1] : undefined
    }

    console.log('Fetching trend stats with params:', params)
    
    const res = await getTrainingStatistics(params)
    console.log('Trend stats response:', res)

    if (res && res.success) {
      console.log('Setting trend stats:', res.data)
      trendStats.value = res.data || getDefaultTrendStats()
      // 更新图表
      initCharts()
    } else {
      console.warn('Invalid trend stats response:', res)
      trendStats.value = getDefaultTrendStats()
      if (!res.success) {
        throw new Error(res.message || '获取统计数据失败')
      }
    }
  } catch (error) {
    console.error('获取趋势统计数据失败:', error)
    ElMessage.error(error.message || '获取趋势统计数据失败')
    trendStats.value = getDefaultTrendStats()
  }
}

// 获取默认的趋势统计数据
const getDefaultTrendStats = () => ({
  totalDuration: 0,
  avgDistance: 0,
  minDuration: 0,
  minDistance: 0,
  maxDistance: 0,
  avgCalories: 0,
  totalCalories: 0,
  totalDistance: 0,
  maxDuration: 0,
  avgDuration: 0
})

// 初始化训练强度分布图
const initIntensityChart = (data) => {
  if (!intensityChartRef.value) return
  
  intensityChart = echarts.init(intensityChartRef.value)
  const option = {
    title: {
      text: '训练强度分布',
      left: 'center'
    },
    tooltip: {
      trigger: 'item'
    },
    legend: {
      orient: 'vertical',
      left: 'left'
    },
    series: [
      {
        name: '训练强度',
        type: 'pie',
        radius: ['40%', '70%'],
        avoidLabelOverlap: false,
        itemStyle: {
          borderRadius: 10,
          borderColor: '#fff',
          borderWidth: 2
        },
        label: {
          show: false,
          position: 'center'
        },
        emphasis: {
          label: {
            show: true,
            fontSize: '20',
            fontWeight: 'bold'
          }
        },
        labelLine: {
          show: false
        },
        data: [
          { value: data.lowIntensity || 20, name: '低强度' },
          { value: data.mediumIntensity || 40, name: '中等强度' },
          { value: data.highIntensity || 30, name: '高强度' }
        ]
      }
    ]
  }
  intensityChart.setOption(option)
}

// 初始化训练进展趋势图
const initProgressChart = (data) => {
  if (!progressChartRef.value) return
  
  progressChart = echarts.init(progressChartRef.value)
  const option = {
    title: {
      text: '训练进展趋势',
      left: 'center'
    },
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'cross',
        label: {
          backgroundColor: '#6a7985'
        }
      }
    },
    legend: {
      data: ['训练距离', '平均配速'],
      top: 30
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis: [
      {
        type: 'category',
        boundaryGap: false,
        data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
      }
    ],
    yAxis: [
      {
        type: 'value',
        name: '距离(km)',
        position: 'left'
      },
      {
        type: 'value',
        name: '配速(min/500m)',
        position: 'right'
      }
    ],
    series: [
      {
        name: '训练距离',
        type: 'line',
        smooth: true,
        data: [5, 7, 6, 8, 9, 7, 8]
      },
      {
        name: '平均配速',
        type: 'line',
        yAxisIndex: 1,
        smooth: true,
        data: [2.5, 2.4, 2.3, 2.4, 2.2, 2.3, 2.1]
      }
    ]
  }
  progressChart.setOption(option)
}

// 初始化训练时间分布图
const initTimeDistributionChart = (data) => {
  if (!timeDistributionChartRef.value) return
  
  timeDistributionChart = echarts.init(timeDistributionChartRef.value)
  const option = {
    title: {
      text: '训练时间分布',
      left: 'center'
    },
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow'
      }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: ['6-9点', '9-12点', '12-15点', '15-18点', '18-21点', '21-24点']
    },
    yAxis: {
      type: 'value',
      name: '训练次数'
    },
    series: [
      {
        name: '训练频次',
        type: 'bar',
        barWidth: '60%',
        data: [2, 4, 3, 5, 6, 2]
      }
    ]
  }
  timeDistributionChart.setOption(option)
}

// 初始化目标完成度图
const initGoalCompletionChart = (data) => {
  if (!goalCompletionChartRef.value) return
  
  goalCompletionChart = echarts.init(goalCompletionChartRef.value)
  const option = {
    title: {
      text: '目标完成度',
      left: 'center'
    },
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow'
      }
    },
    radar: {
      indicator: [
        { name: '训练时长', max: 100 },
        { name: '训练距离', max: 100 },
        { name: '训练频次', max: 100 },
        { name: '平均配速', max: 100 },
        { name: '卡路里消耗', max: 100 }
      ]
    },
    series: [
      {
        type: 'radar',
        data: [
          {
            value: [80, 85, 70, 90, 75],
            name: '目标完成度',
            areaStyle: {
              color: 'rgba(64,158,255,0.3)'
            }
          }
        ]
      }
    ]
  }
  goalCompletionChart.setOption(option)
}

// 初始化训练数据对比图
const initComparisonChart = (data) => {
  if (!comparisonChartRef.value) return
  
  comparisonChart = echarts.init(comparisonChartRef.value)
  const option = {
    title: {
      text: '训练数据周期对比',
      left: 'center'
    },
    tooltip: {
      trigger: 'axis'
    },
    legend: {
      data: ['本周期', '上个周期'],
      top: 30
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: ['训练时长', '训练距离', '消耗卡路里', '平均配速', '训练次数']
    },
    yAxis: {
      type: 'value',
      name: '完成百分比'
    },
    series: [
      {
        name: '本周期',
        type: 'bar',
        data: [120, 110, 105, 95, 115]
      },
      {
        name: '上个周期',
        type: 'bar',
        data: [100, 100, 100, 100, 100]
      }
    ]
  }
  comparisonChart.setOption(option)
}

// 初始化所有图表
const initCharts = () => {
  nextTick(() => {
    initIntensityChart(trendStats.value)
    initProgressChart(trendStats.value)
    initTimeDistributionChart(trendStats.value)
    initGoalCompletionChart(trendStats.value)
    initComparisonChart(trendStats.value)
  })
}

// 监听窗口大小变化，重绘图表
window.addEventListener('resize', () => {
  intensityChart?.resize()
  progressChart?.resize()
  timeDistributionChart?.resize()
  goalCompletionChart?.resize()
  comparisonChart?.resize()
})

// 在组件卸载时销毁图表实例
onUnmounted(() => {
  intensityChart?.dispose()
  progressChart?.dispose()
  timeDistributionChart?.dispose()
  goalCompletionChart?.dispose()
  comparisonChart?.dispose()
})

// 修改表格列的显示
const formatDuration = (minutes) => {
  if (!minutes) return '0分钟'
  // 将分钟数四舍五入到两位小数
  minutes = Number(minutes.toFixed(2))
  const hours = Math.floor(minutes / 60)
  const remainingMinutes = (minutes % 60).toFixed(2)
  return hours > 0 ? `${hours}小时${remainingMinutes}分钟` : `${remainingMinutes}分钟`
}

// 修改页面初始化逻辑
onMounted(async () => {
  loading.value = true
  try {
    await Promise.all([
      refreshHistory(),
      fetchStatistics(),
      handleTrendFilterChange()
    ])
    // 添加初始AI欢迎消息
    chatMessages.value = [
      {
        content: "你好！我是你的AI训练助手。我可以帮你分析训练数据，提供专业建议。有什么我可以帮你的吗？",
        type: "ai",
        time: new Date().toLocaleTimeString()
      }
    ]
    // 初始化图表
    initCharts()
  } catch (error) {
    console.error('初始化失败:', error)
    ElMessage.error('数据加载失败，请刷新页面重试')
  } finally {
    loading.value = false
  }
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

.trend-statistics {
  padding: 20px;
}

.stat-item {
  text-align: center;
  padding: 15px;
  background-color: #f8f9fa;
  border-radius: 8px;
}

.stat-label {
  color: #666;
  font-size: 14px;
  margin-bottom: 8px;
}

.stat-value {
  font-size: 20px;
  font-weight: bold;
  color: #409EFF;
}

.chart-controls {
  display: flex;
  align-items: center;
  gap: 10px;
}

.charts-section {
  margin-top: 30px;
}

.chart-wrapper {
  background: #fff;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0,0,0,0.1);
}

.chart-title {
  font-size: 16px;
  font-weight: bold;
  color: #303133;
  text-align: center;
  margin-bottom: 4px;
}

.chart-subtitle {
  font-size: 12px;
  color: #909399;
  text-align: center;
  margin-bottom: 20px;
}

/* 确保图表容器有足够的高度 */
.chart-container {
  min-height: 1000px;
}
</style>