import Index from '@/pages/frontend/index.vue'
import Login from '@/pages/admin/login.vue'
import AdminIndex from '@/pages/admin/index.vue'
import AdminArticleList from '@/pages/admin/myArticle.vue'
import AdminCategoryList from '@/pages/admin/category-list.vue'
import AdminTagList from '@/pages/admin/CollectList.vue'
import AdminBlogSetting from '@/pages/admin/userProfile.vue'
import UserDetail from '@/pages/admin/userView.vue'
import LikeTagList from '@/pages/admin/LikeList.vue'
import NoteDetail from '../pages/admin/noteDetail.vue'
import TrainingAnalysis from '@/pages/admin/TrainingAnalysis.vue'
import { createRouter, createWebHashHistory } from 'vue-router'
import Admin from '@/layouts/admin/admin.vue'

// 统一在这里声明所有路由
const routes = [
    {
        path: '/', // 路由地址，首页
        component: Login, // 对应组件
        meta: { // meta 信息
            title: 'Airrowing 登录页' // 页面标题
        }
    },
    {
        path: '/login', // 登录页
        component: Login,
        meta: {
            title: 'Airrowing 登录页'
        }
    },
    {
        path: "/admin", // 后台首页
        component: Admin,
        // 使用到 admin.vue 布局的，都需要放置在其子路由下面
        children: [
            {
                path: "/admin/index",
                component: AdminIndex,
                meta: {
                    title: '首页'
                }
            },
            {
                path: "/admin/article/list",
                component: AdminArticleList,
                meta: {
                    title: '我的笔记'
                }
            },
            {
                path: "/admin/category/list",
                component: AdminCategoryList,
                meta: {
                    title: '关注列表'
                }
            },
            {
                path: "/admin/tag/list",
                component: AdminTagList,
                meta: {
                    title: '我的收藏'
                }
            },
            {
                path: "/admin/blog/setting",
                component: AdminBlogSetting,
                meta: {
                    title: '个人信息'
                }
            },
            {
                path: "/admin/like/list",
                component: LikeTagList,
                meta: {
                    title: '我的点赞'
                }
            },
            {
                path: "/admin/note/detail/:id/:userId?",
                component: NoteDetail,
                name: "NoteDetail",
                meta: {
                    title: '笔记详情'
                }
            },
            {
                path: '/admin/training-analysis',
                name: 'training-analysis',
                component: TrainingAnalysis,
                meta: {
                    title: '训练分析'
                }
            }
        ]

    },
    {
        path: '/user/:userId',
        name: 'UserDetail',
        component: UserDetail,
        meta: {
            title: '用户详情'
        }
    }
]

// 创建路由
const router = createRouter({
    // 指定路由的历史管理方式，hash 模式指的是 URL 的路径是通过 hash 符号（#）进行标识
    history: createWebHashHistory(),
    // routes: routes 的缩写
    routes,
})

// 暴露出去
export default router

