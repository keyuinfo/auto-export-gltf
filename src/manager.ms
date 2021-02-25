/*
 * 主Rollout
 * 包含的内容：
 *      一、简装样板间模型自动导出组件
*/


rollout Manager "主下拉框" rolledUp:False silentErrors:False (

    struct simpleRoom(
        nameStr,
        maxFilePathStr = MaxFilePath,

        -------------------------
        -- function
        fn printRoomName = (
            format "本简装样板间的名称为：%\n" nameStr
        ),

        fn printFilePath = (
            format "当前max文件的存储路径为：%\n" maxFilePathStr
        )
    )

    -----------------------------------------------------------------

    local simpleRoomInst = simpleRoom()


    group "简装样板间自动导出控件组" (

        label tip_1 "1、输入完简装样板间的名称后一定要键入Enter" align:#left
        label tip_2 "2、暂存模型时，请先选择对应的模型，在点击对应的按钮" align:#left

        edittext roomName "简装样板间名称：" text:"empty" align:#left

        button selectFloorBtn "暂存floor" align:#center offset:[0, 0] \
            toolTip: "先选择floor模型，再点击该按钮"
        button selectWallBtn "暂存wall" align:#center offset:[0, 0] \
            toolTip: "先选择wall模型，再点击该按钮"
        button selectCurtainBtn "暂存curtain" align:#center offset:[0, 0] \
            toolTip: "先选择curtain模型，再点击该按钮"
        button selectRest1Btn "暂存rest1" align:#center offset:[0, 0] \
            toolTip:"先选择包含门框的rest1模型，再点击该按钮"
        button selectRest2Btn "暂存rest2" align:#center offset:[0, 0] \
            toolTip:"先选择包含吊顶的rest2模型，再点击该按钮"

    )


    on roomName entered txt do (
        format "本简装样板间的名称为：%\n" txt 
        simpleRoomInst.nameStr = txt 
        -- simpleRoomInst.printRoomName()
        -- simpleRoomInst.printFilePath()
    )


    --------------------------------------------------------------------------

    -- 本rollout的事件处理函数
    on Manager open do (

    )

    on Manager close do (

        format "场景数据解析器正在关闭...\n"

    )

    on Manager oktoclose do (
        
    )

    on Manager resized size do (
        --format "After resize operation, the size of Manage Rollout is: %\n" size
    )

    on manager moved pos do (
        --format "After move operation, the position of Manage Rollout is: %\n" pos
    )

)