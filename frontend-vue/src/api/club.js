import axios from "@/axios";

// 俱乐部基础操作
export function createClubService(params) {
    return axios.post("/club/create", params)
        .then(response => response.data)
        .catch(error => {
            console.error("Error creating club:", error);
            throw error;
        });
}

export function updateClubService(params) {
    return axios.post("/club/update", params);
}

export function deleteClubService(params) {
    return axios.post("/club/delete", params);
}

export function getClubDetailsService(params) {
    return axios.post("/club/details", params);
}

// 获取俱乐部列表
export function getClubListService(params) {
    return axios.post("/club/clublist", params)
        .then(response => response.data)
        .catch(error => {
            console.error("Error fetching club list:", error);
            throw error;
        });
}

// 俱乐部成员管理
export function addSecondHostService(params) {
    return axios.post("/club/addHosts", params);
}

export function removeHostService(params) {
    return axios.post("/club/firehost", params);
}

export function getHostListService(params) {
    return axios.post("/club/hostlist", params);
}

export function getClubMembersService(params) {
    return axios.post("/club/members", params);
}

export function removeMemberService(params) {
    return axios.post("/club/clubRemoveMember", params);
}

// 加入申请相关
export function joinClubService(params) {
    return axios.post("/club/joinRequest", params)
        .then(response => response.data)
        .catch(error => {
            console.error("Error joining club:", error);
            throw error;
        });
}

export function reviewJoinRequestService(params) {
    return axios.post("/club/reviewJoinRequest", params);
}

// 退出俱乐部
export function leaveClubService(params) {
    return axios.post("/club/leave", params)
        .then(response => response.data)
        .catch(error => {
            console.error("Error leaving club:", error);
            throw error;
        });
}

// 获取加入申请列表
export function getJoinRequestListService(params) {
    return axios.post("/club/joinRequestList", params)
        .then(response => response.data)
        .catch(error => {
            console.error("Error fetching join requests:", error);
            throw error;
        });
}

export function getClubJoinRequestsService(params) {
    return axios.post("/club/clubJoinRequests", params)
        .then(response => response.data)
        .catch(error => {
            console.error("Error fetching club join requests:", error);
            throw error;
        });
}

// 活动相关
export function publishActivityService(params) {
    return axios.post("/club/publishActivity", params)
        .then(response => response.data)
        .catch(error => {
            console.error("Error publishing activity:", error);
            throw error;
        });
}

export function updateActivityService(params) {
    return axios.post("/club/updateActivity", params);
}

export function deleteActivityService(params) {
    return axios.post("/club/deleteActivity", params);
}

export function getActivityDetailsService(params) {
    return axios.post("/club/activity/details", params);
}

export function getClubActivityListService(params) {
    return axios.post("/club/activityList", params)
        .then(response => response.data)
        .catch(error => {
            console.error("Error fetching activity list:", error);
            throw error;
        });
}

// 活动报名相关
export function signupActivityService(params) {
    return axios.post("/club/activity/signup", params);
}

export function reviewSignupService(params) {
    return axios.post("/club/activity/reviewSignup", params);
}

export function cancelSignupService(params) {
    return axios.post("/club/activity/cancelSignup", params);
}

export function removeActivityMemberService(params) {
    return axios.post("/club/activity/removeMember", params);
}

export function getActivityMembersService(params) {
    return axios.post("/club/activity/signupMembers", params)
        .then(response => response.data)
        .catch(error => {
            console.error("Error fetching activity members:", error);
            throw error;
        });
}

export function getUserSignupsService(params) {
    return axios.post("/club/activity/userSignups", params)
        .then(response => response.data)
        .catch(error => {
            console.error("Error fetching user signups:", error);
            throw error;
        });
}

export function getHostSignupListService(params) {
    return axios.post("/club/activity/hostSignupList", params)
        .then(response => response.data)
        .catch(error => {
            console.error("Error fetching host signup list:", error);
            throw error;
        });
} 