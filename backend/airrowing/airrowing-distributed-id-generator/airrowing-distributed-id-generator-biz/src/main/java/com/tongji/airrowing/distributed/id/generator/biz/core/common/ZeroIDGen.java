package com.tongji.airrowing.distributed.id.generator.biz.core.common;

import com.tongji.airrowing.distributed.id.generator.biz.core.IDGen;

public class ZeroIDGen implements IDGen {
    @Override
    public Result get(String key) {
        return new Result(0, Status.SUCCESS);
    }

    @Override
    public boolean init() {
        return true;
    }
}