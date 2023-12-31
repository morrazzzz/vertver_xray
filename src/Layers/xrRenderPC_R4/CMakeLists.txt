project(xrRender_R4)
set(XRR4_SRC_FILES)

# Files import
file(GLOB_RECURSE XRR4_SOURCE_ALL_FILES CONFIGURE_DEPENDS
    "*.cpp"
	"*.h"
)

file(GLOB_RECURSE XRR4_SOURCE_COMP_FILES CONFIGURE_DEPENDS
    "../xrRender/*.cpp"
	"../xrRender/*.h"
)

file(GLOB_RECURSE XRR4_SOURCE_COMP_BLEND_FILES CONFIGURE_DEPENDS
    "../xrRender/Blender_*.cpp"
	"../xrRender/Blender_*.h"
)

file(GLOB_RECURSE XRR4_SOURCE_BLEND_FILES CONFIGURE_DEPENDS
    "Blender_*.cpp"
	"Blender_*.h"
)

file(GLOB_RECURSE XRR4_SOURCE_DX9_FILES CONFIGURE_DEPENDS
    "../xrRenderDX10/*.cpp"
	"../xrRenderDX10/*.h"
)

file(GLOB_RECURSE XRR4_SOURCE_LUA_FILES CONFIGURE_DEPENDS
    "../../xrEngine/ai_script_lua*.cpp"
	"../../xrEngine/ai_script_lua*.h"
)

# Source groups
source_group("render" FILES ${XRR4_SOURCE_ALL_FILES})
source_group("layers" FILES ${XRR4_SOURCE_COMP_FILES})
source_group("general_dx11" FILES ${XRR4_SOURCE_DX9_FILES})
source_group("lua_ext" FILES ${XRR4_SOURCE_LUA_FILES})
source_group("blend" FILES ${XRR4_SOURCE_COMP_BLEND_FILES})
source_group("blend" FILES ${XRR4_SOURCE_BLEND_FILES})

# Apply list
list(APPEND XRR4_SRC_FILES ${XRR4_SOURCE_ALL_FILES})
list(APPEND XRR4_SRC_FILES ${XRR4_SOURCE_COMP_FILES})
list(APPEND XRR4_SRC_FILES ${XRR4_SOURCE_DX9_FILES})
list(APPEND XRR4_SRC_FILES ${XRR4_SOURCE_LUA_FILES})

# Remove unused files
#list(FILTER XRR4_SRC_FILES EXCLUDE REGEX "../xrRender/HW.cpp")

# xrRender_R4 project
add_library(xrRender_R4 SHARED ${XRR4_SRC_FILES})
target_precompile_headers(xrRender_R4 PRIVATE "stdafx.h")

# Include directories
target_include_directories(xrRender_R4 PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")
target_include_directories(xrRender_R4 PUBLIC "${IXRAY_SDK_INC}/fsr2")
target_include_directories(xrRender_R4 PUBLIC "${IXRAY_SDK_INC}/dlss")

# project defines 
target_compile_definitions(xrRender_R4 PRIVATE _WINDOWS)
target_compile_definitions(xrRender_R4 PRIVATE XRRENDER_R4_EXPORTS)
target_compile_definitions(xrRender_R4 PRIVATE USE_DX11)
target_compile_definitions(xrRender_R4 PRIVATE _USRDLL)

add_compile_options(/fp:fast)
add_compile_options("$<$<CONFIG:Debug>:/MD>")
target_compile_definitions(xrRender_R4 PRIVATE "$<$<CONFIG:Debug>:DEBUG>")

# Linker list
target_link_directories(xrRender_R4 PRIVATE ${IXRAY_SDK_LIB})
target_link_libraries(xrRender_R4 PUBLIC xrEngine)
target_link_libraries(xrRender_R4 PUBLIC xrAppLayer)
target_link_libraries(xrRender_R4 PUBLIC xrParticles)
target_link_libraries(xrRender_R4 PUBLIC "d3dcompiler.lib")
target_link_libraries(xrRender_R4 PUBLIC "dxgi.lib")
target_link_libraries(xrRender_R4 PUBLIC "d3d11.lib")

# Nuget
add_custom_command(TARGET ${PROJECT_NAME}
    PRE_BUILD
    COMMAND ${CMAKE_HOME_DIRECTORY}/nuget restore ${CMAKE_CURRENT_SOURCE_DIR}/Packages.config -SolutionDirectory ${CMAKE_BINARY_DIR}
)

## DX SDK
target_include_directories(xrRender_R4 PUBLIC "${CMAKE_BINARY_DIR}/packages/directxmesh_desktop_win10.2023.4.28.1/include/")
target_include_directories(xrRender_R4 PUBLIC "${CMAKE_BINARY_DIR}/packages/directxtex_desktop_win10.2023.6.14.1/include/")

if(NOT "${CMAKE_VS_PLATFORM_NAME}" MATCHES "(x64)")
    target_link_libraries(xrRender_R4 PUBLIC "ffx_fsr2_api_dx11_x86.lib")
    target_link_libraries(xrRender_R4 PUBLIC "ffx_fsr2_api_x86.lib")
    target_link_libraries(xrRender_R4 PUBLIC ${CMAKE_BINARY_DIR}/packages/directxtex_desktop_win10.2023.6.14.1/native/lib/x86/release/DirectXTex.lib)
else()
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${IXRAY_SDK_BIN}nvngx_dlss.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/$<CONFIG>/
    )

    target_link_libraries(xrRender_R4 PUBLIC "nvsdk_ngx_d.lib")
    #target_link_libraries(xrRender_R4 PUBLIC "ffx_fsr2_api_dx11_x64.lib")
    #target_link_libraries(xrRender_R4 PUBLIC "ffx_fsr2_api_x64.lib")
    target_link_libraries(xrRender_R4 PUBLIC ${CMAKE_BINARY_DIR}/packages/directxtex_desktop_win10.2023.6.14.1/native/lib/x64/release/DirectXTex.lib)
endif()
