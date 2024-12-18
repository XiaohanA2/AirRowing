<template>
  <div class="note-container">
    <el-card class="note-display-area" shadow="hover">
      <div class="note-cards">
        <el-row :gutter="20" justify="center">
          <el-col :span="8" v-for="note in notesWithPlaceholders" :key="note.id || note.placeholder">
            <el-card class="note-card" shadow="hover" :class="{ 'placeholder-card': note.placeholder }"
              @click="goToNoteDetail(note.id, note.creatorId)">

              <div v-if="!note.placeholder">
                <!-- 默认显示 developer.png，如果 note.imgUris 存在则覆盖 -->
                <img :src="note.imgUris && note.imgUris[0] ? note.imgUris[0] : '/assets/developer.png'"
                  @error="handleImageError" alt="Note Image" class="note-image" />
                <h3>{{ note.title }}</h3>
                <p>Updated: {{ note.updateTime }}</p>
                <div class="creator-info">
                  <img :src="note.avatar" alt="Creator Avatar" class="creator-avatar" />
                  <span>{{ note.creatorName }}</span>
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>
      <div class="pagination-container">
        <el-pagination
          v-model:current-page="currentPage"
          :page-size="pageSize"
          :total="totalNotes"
          :page-count="maxPage"
          layout="prev, jumper, next"
          @current-change="handlePageChange"
          background
        />
      </div>
    </el-card>
  </div>
</template>

<script>
import { getNoteListService, getNoteDetailService } from "@/api/note.js";
import { ElMessage } from "element-plus";

export default {
  data() {
    return {
      notes: [], // 当前页的笔记数据
      currentPage: 1, // 当前页码
      currentPageInput: 1, // 输入框中的页码
      pageSize: 9, // 每页固定展示 9 条数据
      totalNotes: 0, // 总笔记数，从后端获取
    };
  },
  computed: {
    maxPage() {
      return Math.max(1, Math.ceil(this.totalNotes / this.pageSize));
    },
    notesWithPlaceholders() {
      const placeholders = Array.from({ length: this.pageSize - this.notes.length }, (_, index) => ({
        placeholder: true,
        id: `placeholder-${index}`,
      }));
      return [...this.notes, ...placeholders];
    },
  },
  methods: {
    fetchNotes() {
      const params = {
        page: this.currentPage,
        size: this.pageSize,
      };
      getNoteListService(params)
        .then(async (response) => {
          if (response && response.length > 0) {
            const detailedNotes = await Promise.all(
              response.map(async (note) => {
                const detailResponse = await getNoteDetailService({ id: note.id });
                return {
                  ...note,
                  ...detailResponse.data,
                };
              })
            );
            this.notes = detailedNotes;
            this.totalNotes = this.currentPage * this.pageSize + response.length;
            this.currentPageInput = this.currentPage;
          } else {
            ElMessage.warning("没有更多笔记了~");
            if (this.currentPage > 1) {
              this.currentPage--;
              this.currentPageInput = this.currentPage;
            }
          }
        })
        .catch((error) => {
          console.error("Error fetching note list:", error);
          ElMessage.error("Failed to fetch notes.");
        });
    },
    handlePageChange(page) {
      this.currentPage = page;
      this.currentPageInput = page;
      this.fetchNotes();
    },
    goToNoteDetail(noteId, userId) {
      if (!noteId) return;
      this.$router.push({ name: "NoteDetail", params: { id: noteId, userId } });
    },
    handleImageError(event) {
      event.target.src = "/assets/developer.png";
    },
  },
  mounted() {
    this.fetchNotes();
  },
};
</script>

<style scoped>
.note-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 73vh;
  overflow: hidden;
}

.note-display-area {
  width: 100%;
  max-height: 100%;
  overflow-y: auto;
  padding: 20px;
}

.note-cards {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
}

.note-card {
  margin-bottom: 20px;
  text-align: center;
  height: 220px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  transition: all 0.3s ease;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}

.note-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.12);
}

.note-card:not(.placeholder-card)::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to bottom, transparent 50%, rgba(0, 0, 0, 0.03));
  opacity: 0;
  transition: opacity 0.3s ease;
}

.note-card:not(.placeholder-card):hover::before {
  opacity: 1;
}

.note-image {
  width: 100%;
  height: 80px;
  object-fit: cover;
  margin-bottom: 10px;
  border-radius: 4px;
  transition: transform 0.3s ease;
}

.note-card:hover .note-image {
  transform: scale(1.05);
}

.creator-info {
  display: flex;
  align-items: center;
  margin-top: 10px;
  padding: 5px 10px;
  background: rgba(0, 0, 0, 0.02);
  border-radius: 15px;
  transition: background 0.3s ease;
}

.note-card:hover .creator-info {
  background: rgba(0, 0, 0, 0.04);
}

.creator-avatar {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  margin-right: 10px;
  border: 2px solid #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.placeholder-card {
  background-color: #f9f9f9;
  border: 1px dashed #e0e0e0;
  opacity: 0.6;
  transition: opacity 0.3s ease;
}

.placeholder-card:hover {
  opacity: 0.8;
}

.pagination-container {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 20px;
  padding: 10px 0;
}

:deep(.el-pagination) {
  --el-pagination-hover-color: #409eff;
  --el-pagination-button-color: #606266;
  --el-pagination-button-disabled-color: #c0c4cc;
  --el-pagination-button-bg-color: #fff;
  --el-pagination-hover-bg-color: #ecf5ff;
}

:deep(.el-pagination .el-input__inner) {
  text-align: center;
}
</style>
