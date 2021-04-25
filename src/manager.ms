/*
 * 主Rollout
 * 包含的内容：
 *      一、简装样板间模型自动导出组件
*/

Assembly = dotNetClass "System.Reflection.Assembly"
Assembly.loadfrom "F:\\3dsMax\\3ds Max 2017\\bin\\assemblies\\Max2Babylon.dll"
global maxScriptManager = dotNetObject "Max2Babylon.MaxScriptManager"

/*
-- draco压缩的参数设置
global dracoParam = dotNetObject "BabylonExport.Entities.DracoParameters"
dracoParam.compressionLevel = 10
dracoParam.quantizeColorBits = 8
dracoParam.quantizeGenericBits = 12
dracoParam.quantizeNormalBits = 10
dracoParam.quantizePositionBits = 14
dracoParam.quantizeTexcoordBits = 16
*/

rollout Manager "简装样板间自动导出控件组" rolledUp:False silentErrors:False (

    struct simpleRoom(
        nameStr,
        texturePath = MaxFilePath + "texture",

        -------------------------
        -- function
        fn printRoomName = (
            format "本简装样板间的名称为：%\n" nameStr
        ),

        fn printFilePath = (
            format "当前max文件的存储路径为：%\n" MaxFilePath 
        ),

        fn exportModel = (
            
            selSetsCnt = getNumNamedSelSets()

            try (
                for i = 1 to selSetsCnt by 1 do (
                    selSetNameStr = getNamedSelSetName i
                    selSetName = selSetNameStr as Name 

                    -- w字母自动大写问题的纠正
                    if selSetNameStr[1] == "W" then (
                        selSetNameStr[1] = "w"
                    )
                    if selSetNameStr[1] == "D" then (
                        selSetNameStr[1] = "d"
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
                    param.textureFolder = texturePath
                    param.writeTextures = true 
                    param.overwriteTextures = true 
                    param.mergeAOwithMR = false
                    -- param.dracoCompression = true
                    -- param.dracoParams = dracoParam
 

                    maxScriptManager.Export param 

                    outputStr = nameStr + selSetNameStr + ".gltf文件导出成功\n\n"
                    format outputStr

                    sleep 5
                )
            ) catch (
                local tmpStr = nameStr + "简装样板导出失败\n\n请仔细排除出错的原因\n\n请手动删除不完整的gltf文件"
                messageBox tmpStr title:"运行时错误提示" beep:True 
            )

            format "%，简装样板间的模型已全部导出完成\n\n\n\n\n" nameStr 

            local tmpStr = nameStr + "简装样板间的模型已全部导出完成\n\n请继续导出下一个简装样板间"
            queryBox tmpStr title:"提示对话框" beep:True 
            
        )
    )

    -----------------------------------------------------------------
    -- 创建一个简装样板间实例
    local simpleRoomInst = simpleRoom()


    group "提示信息" (
        label tip_1 "1、输入完简装样板间的名称后一定要键入Enter" align:#left
        label tip_2 "2、暂存模型时，请先选择对应的模型，在点击对应的按钮" align:#left
    )

    group "参数设置控件" (
        edittext roomName "简装样板间名称：" text:"empty" align:#left
        -- checkbox obtainCeiling "是否存在可被替换的吊顶：" align:#left checked: False 
    )

    group "可被替换的模型对应的控件" (
        -- button selectCeilingBtn "暂存ceiling" align:#center offset:[0, 0] toolTip: "先选择ceiling模型，再点击该按钮"
        label tip_3 "暂时不存在该类模型" align:#left
    )

    group "仅可被更换材质的模型对应的控件" (
        button selectFloorBtn "暂存floor" align:#center offset:[0, 0] \
            toolTip: "先选择floor模型，再点击该按钮"
        button selectWallBtn "暂存wall" align:#center offset:[0, 0] \
            toolTip: "先选择wall模型，再点击该按钮"
        button selectLivingRoomCurtainBtn "暂存客餐厅的curtain" align:#center offset:[0, 0] \
            toolTip: "先选择客餐厅的curtain模型，再点击该按钮"
        button selectBedRoomCurtainBtn "暂存卧室的curtain" align:#center offset:[0, 0] \
            toolTip: "先选择卧室的curtain模型，再点击该按钮"
        button selectDoorBtn "暂存door" align:#center offset:[0, 0] \
            toolTip:"先选择所有的door模型，再点击该按钮"
        button selectRest1Btn "暂存门框与踢脚线" align:#center offset:[0, 0] \
            toolTip:"先选择包含门框和踢脚线的rest1模型，再点击该按钮"        
    )

    group "其余模型" (
        button selectRest2Btn "暂存rest2" align:#center offset:[0, 0] \
            toolTip:"先选择包含吊顶的rest2模型，再点击该按钮"
    )

    group "最终导出控件" (
        checkbox obtainDoor "是否存在可替换材质的门：" align:#center checked: True
        button exportBtn "导出模型" align:#center offset:[0, 0] 
    )


    on roomName entered txt do (
        format "本简装样板间的名称为：%\n" txt 
        simpleRoomInst.nameStr = txt 

        -- 创建一个texture子文件夹，为了成功的批量导出GLTF文件
        -- 即使是重复创建也没关系
        res = makeDir simpleRoomInst.texturePath
        if res == true then (
            format "texture子文件夹创建成功\n"
        ) 
    )

    -- 模型按类型分开暂存
    on selectFloorBtn pressed do (

        SelectionSets[#floor] = getCurrentSelection()

    )

    on selectWallBtn pressed do (

        SelectionSets[#wall] = getCurrentSelection()

    )

    on selectLivingRoomCurtainBtn pressed do (

        SelectionSets[#lrCurtain] = getCurrentSelection()

    )

    on selectBedRoomCurtainBtn pressed do (

        SelectionSets[#brCurtain] = getCurrentSelection()

    )

    on selectDoorBtn pressed do (

        SelectionSets[#door] = getCurrentSelection()

    )

    on selectRest1Btn pressed do (

        SelectionSets[#rest1] = getCurrentSelection()

    )

    
    on selectRest2Btn pressed do (

        SelectionSets[#rest2] = getCurrentSelection()

    )
    
    on obtainDoor changed var do (
        format "本简装样板间是否具有可替换材质的门：%\n" var
        if var == False then (
            deleteItem SelectionSets "Door"
            format "名称为door的命名选择集已被删除\n"
        )
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