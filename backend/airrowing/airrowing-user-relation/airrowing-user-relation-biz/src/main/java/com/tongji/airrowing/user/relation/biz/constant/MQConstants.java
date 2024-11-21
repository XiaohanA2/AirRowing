package com.tongji.airrowing.user.relation.biz.constant;

public interface MQConstants {

    /**
     * Topic: 关注、取关共用一个
     */
    String AIR_TOPIC_FOLLOW_OR_UNFOLLOW = "FollowUnfollowTopic";

    /**
     * 关注标签
     */
    String AIR_TAG_FOLLOW = "Follow";

    /**
     * 取关标签
     */
    String AIR_TAG_UNFOLLOW = "Unfollow";

    /**
     * Topic: 关注数计数
     */
    String AIR_TOPIC_COUNT_FOLLOWING = "CountFollowingTopic";

    /**
     * Topic: 粉丝数计数
     */
    String AIR_TOPIC_COUNT_FANS = "CountFansTopic";
}


