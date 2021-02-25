/*
 * 主Rollout
 * 包含的内容：
 *      一、简装样板间模型自动导出组件
*/

Assembly = dotNetClass "System.Reflection.Assembly"
Assembly.loadfrom "F:\\3dsMax\\3ds Max 2017\\bin\\assemblies\\Max2Babylon.dll"
global maxScriptManager = dotNetObject "Max2Babylon.MaxScriptManager"


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
        ),

        fn exportModel = (
            
            selSetsCnt = getNumNamedSelSets()

            for i = 1 to selSetsCnt by 1 do (
                selSetNameStr = getNamedSelSetName i
                selSetName = selSetNameStr as Name 

                if selSetNameStr[1] == "W" then (
                    selSetNameStr[1] = "w"
                )

                gltfFileName = nameStr + selSetNameStr + ".gltf"
                gltfPathName = MaxFilePath + gltfFileName
                format "当前gltf文件的完整名称为：%\n" gltfPathName
                param = maxScriptManager.InitParameters gltfPathName

                -- 导出参数设置
                select SelectionSets[selSetName]
                param.outputFormat = "gltf"
                param.exportOnlySelected = true
                param.exportMaterials = true
                param.exportTextures = true
                texturePath = MaxFilePath + "\\texture"
                param.textureFolder = texturePath
                param.writeTextures = true 
                param.overwriteTextures = true 
                param.mergeAOwithMR = true 


                maxScriptManager.Export param 

                outputStr = selSetNameStr + ".gltf文件导出成功\n\n\n"
            )

            format "该简装样板间的模型已全部导出完成\n"
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

        button exportBtn "导出模型" align:#center offset:[0, 0] 

    )


    on roomName entered txt do (
        format "本简装样板间的名称为：%\n" txt 
        simpleRoomInst.nameStr = txt 
    )

    -- 模型按类型分开暂存
    on selectFloorBtn pressed do (

        SelectionSets[#floor] = getCurrentSelection()

    )

    on selectWallBtn pressed do (

        SelectionSets[#wall] = getCurrentSelection()

    )

    on selectCurtainBtn pressed do (

        SelectionSets[#curtain] = getCurrentSelection()

    )

    on selectRest1Btn pressed do (

        SelectionSets[#rest1] = getCurrentSelection()

    )

    on selectRest2Btn pressed do (

        SelectionSets[#rest2] = getCurrentSelection()

    )

    on exportBtn pressed do (
        simpleRoomInst.exportModel()
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