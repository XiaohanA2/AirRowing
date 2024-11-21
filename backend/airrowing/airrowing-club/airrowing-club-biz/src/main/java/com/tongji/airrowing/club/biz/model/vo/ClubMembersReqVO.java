package com.tongji.airrowing.club.biz.model.vo;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ClubMembersReqVO {

    @NotNull(message = "俱乐部ID不能为空")
    private Long clubId;

    @NotNull(message = "页码不能为空")
    private Integer page;

    @NotNull(message = "每页条数不能为空")
    private Integer size;
}

