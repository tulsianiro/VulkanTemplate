VULKAN_SDK = os.getenv("VULKAN_SDK")

IncludeDir = {}
IncludeDir["GLFW"] = "%{wks.location}/Vendor/GLFW/include"
IncludeDir["glm"] = "%{wks.location}/Vendor/glm"
IncludeDir["VulkanSDK"] = "%{VULKAN_SDK}/Include"

LibraryDir = {}
LibraryDir["VulkanSDK"] = "%{VULKAN_SDK}/Lib"

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

workspace "VulkanTemplate"
	architecture "x86_64"
	startproject "VulkanTemplate"
	configurations { "Debug", "Release" }
	flags
	{
		"MultiProcessorCompile"
	}

	group("Dependencies")
		include "Vendor/glfw"
	group ""

project "VulkanTemplate"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++17"
	staticruntime "on"

	targetdir ("%{wks.location}/Build/" .. outputdir .. "/%{prj.name}")
	objdir ("%{wks.location}/Build/" .. outputdir .. "/%{prj.name}")

	files
	{
		"Source/**.h",
		"Source/**.cpp",
		"%{wks.location}/Vendor/glm/glm/**.hpp",
		"%{wks.location}/Vendor/glm/glm/**.inl",
	}

	defines
	{
		"_CRT_SECURE_NO_WARNINGS",
	}

	includedirs
	{
		"Source",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.glm}",
		"%{IncludeDir.VulkanSDK}"
	}

	libdirs { "%{LibraryDir.VulkanSDK}" }

	links
	{
		"GLFW", "%{LibraryDir.VulkanSDK}/vulkan-1"
	}

	filter "system:windows"
		systemversion "latest"

	filter "configurations:Debug"
		defines "DEBUG"
		runtime "Debug"
		symbols "on"
	
	filter "configurations:Release"
		defines "RELEASE"
		runtime "Release"
		optimize "on"
