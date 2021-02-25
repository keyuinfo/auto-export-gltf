/*
 * 本工具主要被用来在一定程度上自动化的将模型导出为gltf文件
 * 作者：马后义
 * 时间：2021年2月25日，15点00分
*/

global Framework = newRolloutFloater "3D模型自动导出工具" 320 600 1000 150

include "manager.ms"

function main arg = (
    addRollout Manager Framework rolledUp:False

    format "%\n" arg
)

main "3D模型自动导出工具正在运行..."