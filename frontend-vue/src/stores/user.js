import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getUserInfo, logout as apiLogout } from '@/api/admin/user'
import { removeToken } from '@/composables/cookie'

export const useUserStore = defineStore('user', () => {
  // 用户信息
  const userInfo = ref({})

  // 设置用户信息
  function setUserInfo() {
    // 调用后头获取用户信息接口
    getUserInfo().then(res => {
      if (res.success == true) {
        userInfo.value = res.data
      }
    })
  }

  // 退出登录
  async function logout() {
    try {
      // 调用后端的登出接口
      const res = await apiLogout();
      if (res.success) {
        console.log("Successfully logged out from server");

        // 删除 Token
        removeToken();
        // 清除用户信息
        userInfo.value = {};
      } else {
        console.error("Server logout failed:", res.message);
      }
    } catch (error) {
      console.error("Error while logging out:", error);
    }
  }

  return { userInfo, setUserInfo, logout };
},
  {
    // 开启持久化
    persist: true,
  }
)