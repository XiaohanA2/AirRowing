<template>
  <div class="common-container">
    <div class="training-analysis-container">
      <!-- 左侧部分 -->
      <div class="left-section">
        <!-- 训练历史记录 -->
        <el-card class="history-section">
          <template #header>
            <div class="card-header">
              <span>训练历史记录</span>
              <el-button type="primary" size="small" @click="refreshHistory">
                <el-icon>
                  <Refresh />
                </el-icon>
              </el-button>
            </div>
          </template>
          <el-scrollbar height="300px">
            <div v-if="trainingHistory.length === 0" class="empty-text">
              暂无训练记录
            </div>
            <el-timeline v-else>
              <el-timeline-item v-for="(record, index) in trainingHistory" :key="index"
                :timestamp="formatDate(record.trainingDate)" placement="top">
                <el-card>
                  <div class="training-record">
                    <h4>Airrowing Training</h4>
                    <div class="record-stats">
                      <span><el-icon>
                          <Timer />
                        </el-icon> {{ record.duration }}分钟</span>
                      <span><el-icon>
                          <Position />
                        </el-icon> {{ record.distance }}公里</span>
                      <span v-if="record.calories">
                        <el-icon>
                          <Aim />
                        </el-icon> {{ record.calories }}卡路里
                      </span>
                    </div>
                    <div class="record-status">
                      <el-tag :type="record.status === 1 ? 'success' : 'warning'" size="small">
                        {{ record.status === 1 ? '已完成' : '进行中' }}
                      </el-tag>
                    </div>
                  </div>
                </el-card>
              </el-timeline-item>
            </el-timeline>
          </el-scrollbar>
        </el-card>

        <!-- 上传训练记录 -->
        <el-card class="upload-section">
          <template #header>
            <div class="card-header">
              <span>上传训练记录</span>
            </div>
          </template>
          <el-form :model="uploadForm" label-width="100px" class="upload-form">
            <el-form-item label="训练时长">
              <el-input-number v-model="uploadForm.duration" :min="1" controls-position="right"
                placeholder="请输入训练时长(分钟)" />
            </el-form-item>
            <el-form-item label="训练距离">
              <el-input-number v-model="uploadForm.distance" :min="0" :precision="1" :step="0.1"
                controls-position="right" placeholder="请输入训练距离(公里)" />
            </el-form-item>
            <el-form-item label="消耗卡路里">
              <el-input-number v-model="uploadForm.calories" :min="0" :precision="1" controls-position="right"
                placeholder="请输入消耗卡路里(可选)" />
            </el-form-item>
            <el-form-item label="训练文件">
              <el-upload class="upload-demo" :action="uploadAction" :on-success="handleUploadSuccess"
                :on-error="handleUploadError" :before-upload="beforeUpload">
                <el-button type="primary">选择文件</el-button>
              </el-upload>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="submitTrainingRecord">
                提交记录
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </div>

      <!-- 右侧部分 -->
      <div class="right-section">
        <!-- AI 聊天框 -->
        <el-card class="chat-section">
          <template #header>
            <div class="card-header">
              <span>AI 训练助手</span>
              <el-button type="primary" size="small" @click="clearChat">
                清空对话
              </el-button>
            </div>
          </template>
          <div class="chat-container">
            <el-scrollbar height="300px" ref="chatScrollbar">
              <div class="chat-messages">
                <div v-for="(msg, index) in chatMessages" :key="index" :class="['message', msg.type]">
                  <div class="message-content">{{ msg.content }}</div>
                  <div class="message-time">{{ msg.time }}</div>
                </div>
              </div>
            </el-scrollbar>
            <div class="chat-input">
              <el-input v-model="chatInput" placeholder="请输入您的问题" @keyup.enter="sendMessage">
                <template #append>
                  <el-button @click="sendMessage">发送</el-button>
                </template>
              </el-input>
            </div>
          </div>
        </el-card>

        <!-- 分析展示框 -->
        <el-card class="analysis-section">
          <template #header>
            <div class="card-header">
              <span>训练分析报告</span>
              <el-button type="primary" size="small" @click="refreshAnalysis">
                刷新报告
              </el-button>
            </div>
          </template>
          <el-scrollbar height="300px">
            <div class="analysis-content" v-html="analysisContent"></div>
          </el-scrollbar>
        </el-card>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'

// 训练历史记录
const trainingHistory = ref([])
const uploadForm = ref({
  duration: 30,
  distance: 5.0,
  calories: null,
  file: null
})
const chatMessages = ref([])
const chatInput = ref('')
const analysisContent = ref('')
const chatScrollbar = ref(null)

// 上传相关配置
const uploadAction = '/api/training/upload' // 替换为实际的上传接口

// 获取训练历史记录
const refreshHistory = async () => {
  try {
    trainingHistory.value = [
      {
        trainingDate: "2024-03-15T09:30:00",
        duration: 45,
        distance: 5.2,
        calories: 350.5,
        status: 1,
        type: "airrowing"
      },
      {
        trainingDate: "2024-03-14T16:00:00",
        duration: 60,
        distance: 7.5,
        calories: 400,
        status: 1,
        type: "airrowing"
      },
      // ... 添加更多记录
    ]
  } catch (error) {
    ElMessage.error('获取历史记录失败')
  }
}

// 上传成功处理
const handleUploadSuccess = (response) => {
  ElMessage.success('上传成功')
  uploadForm.value.file = response.data
}

// 上传失败处理
const handleUploadError = () => {
  ElMessage.error('上传失败')
}

// 上传前验证
const beforeUpload = (file) => {
  // 在这里添加文件验证逻辑
  return true
}

// 提交训练记录
const submitTrainingRecord = async () => {
  try {
    const trainingData = {
      ...uploadForm.value,
      trainingDate: new Date().toISOString(),
      status: 1,
      type: 'airrowing'
    }
    // 这里替换为实际的API调用
    // await submitRecord(trainingData)
    ElMessage.success('提交成功')
    uploadForm.value = {
      duration: 30,
      distance: 5.0,
      calories: null,
      file: null
    }
    refreshHistory()
  } catch (error) {
    ElMessage.error('提交失败')
  }
}

// 发送聊天消息
const sendMessage = async () => {
  if (!chatInput.value.trim()) return

  const newMessage = {
    content: chatInput.value,
    type: 'user',
    time: new Date().toLocaleTimeString()
  }
  chatMessages.value.push(newMessage)

  try {
    // 这里替换为实际的API调用
    // const response = await fetch('/api/chat', {
    //   method: 'POST',
    //   body: JSON.stringify({ message: chatInput.value })
    // })
    // const aiResponse = await response.json()

    // 模拟AI回复
    setTimeout(() => {
      chatMessages.value.push({
        content: '这是AI的回复',
        type: 'ai',
        time: new Date().toLocaleTimeString()
      })
      scrollToBottom()
    }, 1000)

    chatInput.value = ''
  } catch (error) {
    ElMessage.error('发送消息失败')
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
  } catch (error) {
    ElMessage.error('获取分析报告失败')
  }
}

// 添加日期格式化函数
const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

onMounted(() => {
  refreshHistory()
  refreshAnalysis()
  // 添加初始聊天记录
  chatMessages.value = [
    {
      content: "你好！我是你的AI训练助手。我注意到你最近的划船训练很有规律，有什么可以帮你的吗？",
      type: "ai",
      time: "09:00:00"
    },
    {
      content: "我想知道如何提高我的长距离划船效率",
      type: "user",
      time: "09:01:23"
    },
    {
      content: "根据你最近的训练数据，我建议：1. 注意配速控制，前半程不要过快 2. 保持呼吸节奏稳定 3. 每5000米可以适当补充能量。需要我详细解释这些要点吗？",
      type: "ai",
      time: "09:01:45"
    }
  ]
})
</script>

<style scoped>
.common-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 78vh;
  /* 占满窗口高度 */
  overflow: hidden;
  /* 禁止外部滚动 */
  padding: 0;
  background-color: #f5f5f5;
}

.training-analysis-container {
  display: flex;
  gap: 20px;
  padding: 20px;
  height: calc(100vh - 120px);
}

.left-section,
.right-section {
  display: flex;
  flex-direction: column;
  gap: 20px;
  width: 50%;
}

.history-section,
.upload-section,
.chat-section,
.analysis-section {
  flex: 1;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.chat-container {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.chat-messages {
  padding: 10px;
}

.message {
  margin-bottom: 10px;
  padding: 8px 12px;
  border-radius: 6px;
  max-width: 80%;
}

.message.user {
  background-color: #e8f5fe;
  margin-left: auto;
}

.message.ai {
  background-color: #f4f4f5;
  margin-right: auto;
}

.message-content {
  word-break: break-word;
}

.message-time {
  font-size: 12px;
  color: #999;
  margin-top: 4px;
}

.chat-input {
  margin-top: auto;
  padding: 10px 0;
}

.empty-text {
  text-align: center;
  color: #999;
  padding: 20px 0;
}

.analysis-content {
  padding: 10px;
  line-height: 1.6;
}

.upload-form {
  overflow-y: auto;
}

.training-record {
  .record-stats {
    display: flex;
    gap: 16px;
    margin: 10px 0;

    span {
      display: flex;
      align-items: center;
      gap: 4px;
      color: #666;

      .el-icon {
        font-size: 16px;
      }
    }
  }

  .record-status {
    display: flex;
    justify-content: flex-end;
  }
}
</style>