import axios from "axios";
import { getToken } from "@/composables/cookie"
import { showMessage } from '@/composables/util'

// 创建 Axios 实例
const instance = axios.create({
    baseURL: "/api", // 你的 API 基础 URL
    timeout: 70000, // 请求超时时间
})

// 添加请求拦截器
instance.interceptors.request.use(function (config) {
    // 在发送请求之前做些什么
    const token = getToken()
    console.log('统一添加请求头中的 Token:' + token)

    // 当 token 不为空时
    if (token) {
        // 添加请求头, key 为 Authorization，value 值的前缀为 'Bearer '
        //config.headers['Authorization'] = 'Bearer ' + token
        config.headers['Authorization'] = `Bearer ${token}`;
    }

    return config;
}, function (error) {
    // 对请求错误做些什么
    return Promise.reject(error)
});

// 添加响应拦截器
instance.interceptors.response.use(
    function (response) {
        // 对响应数据做点什么
        return response.data
    },
    function (error) {
        // 对响应错误做点什么
        const config = error.config; // 获取请求的配置信息
        const silent = config?.silent; // 判断是否需要静默处理

        if (!silent) {
            let errorMsg = error.response?.message || '请求失败';
            // 弹错误提示
            showMessage(errorMsg, 'error');
        } else {
            console.warn('请求失败但静默处理:', error);
        }

        return Promise.reject(error);
    })

// 暴露出去
export default instance;