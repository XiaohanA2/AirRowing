package com.tongji.airrowing.club.biz.domain.dataobject;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder

public class UserDO {
    private Long id;

    private String airrowingId;

    private String password;

    private String nickname;

    private String avatar;

    private LocalDateTime birthday;

    private String backgroundImg;

    private String phone;

    private Byte sex;

    private Byte status;

    private String introduction;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    private Boolean isDeleted;

    private String email;

}