local solutionName = "graphics-study"

local prefix = _OPTIONS["prefix"] or "./dist/glew"

-- Directory vars
local dirWorking = "../"
local dirBinary = "../bin"
local dirLib = "../lib/"
local dirDep = "../dep/"
local dirSource = "../src/"
local dirBuild = "../build/"
local dirObjectFiles = "../temp/"

local flagsRelease = {
  "Symbols",
  "FatalWarnings",
  "Optimize",
  "FloatFast",
  "OptimizeSpeed",
  "NoMinimalRebuild",
  "NoEditAndContinue",
}

local flagsDebug = {
  "Symbols",
  "FatalWarnings",
  "NoMinimalRebuild",
  "FloatFast",
  "NoEditAndContinue",
  "NoIncrementalLink",
}

-- Preprocessor defines
local definesDebug = {
  "_CRT_SECURE_NO_WARNINGS",
  "DEBUG"
}

local definesRelease = {
  "AK_OPTIMIZED",
  "_CRT_SECURE_NO_WARNINGS",
  "NDEBUG"
}

-- Clean Function
newaction {
  trigger     = "clean",
  description = "Removes the build directory.",
  execute     = function ()
    os.rmdir(dirBuild)
    os.rmdir(dirObjectFiles)
    os.rmdir(dirBinary)
    print("done.")
  end
}

if (_ACTION ~= nil) then
  solution(solutionName)
    location(dirBuild .. _ACTION)
    configurations {"Debug", "Release"}
    platforms { "x32", "x64" }
    startproject "graphics-study"

  project("glew3.2.1-static")
    kind("StaticLib")
    language("C++")

    includedirs { dirLib .. "glew/include" }

    files 
    {
      dirLib .. "glew/include/GLFW/*.h",
      dirLib .. "glew/src/*.c",
    }

    excludes
    {
      dirLib .. "glew/src/cocoa_*.c",
      dirLib .. "glew/src/linux_*.c",
      dirLib .. "glew/src/mir_*c",
      dirLib .. "glew/src/posix_*.c",
      dirLib .. "glew/src/wl_*.c",
      dirLib .. "glew/src/x11_*.c",
      dirLib .. "glew/src/glx_*.c"
    }

    objdir(dirObjectFiles)
    targetdir(dirLib .. "glew/lib")
    debugdir(dirLib)
    
    defines 
    {
      "_CRT_SECURE_NO_WARNINGS",
      "_GLFW_WIN32",
      "WIN32",
      "WIN32_LEAN_AND_MEAN",
      "VC_EXTRALEAN"
    }

    configuration "debug"
      defines { "DEBUG" }
      flags { "Symbols", "NoEditAndContinue"}
    
    configuration "release"
      defines { "NDEBUG" }
      flags { "Optimize", "NoEditAndContinue" }

    configuration { "debug", "x32" }
      targetname "glew32d"

	  configuration  { "debug", "x64" }
      targetname "glew64d"

	  configuration { "release", "x32" }
      targetname "glew32"       
        
	  configuration  { "release", "x64" }
      targetname "glew64"

    project("graphics-study")
      kind("ConsoleApp")
      language("C++")
      includedirs { 
        dirLib .. "glew/include",
        dirDep .. "glad/include",
        dirDep .. "**"
            }
      dependson { "glew3.2.1-static" }

      objdir(dirObjectFiles)
      targetdir(dirBinary)
      debugdir(dirBinary)

      files 
      {
        dirSource .. "graphics-study/*.h",
        dirSource .. "graphics-study/*.c",
        dirSource .. "graphics-study/*.hpp",
        dirSource .. "graphics-study/*.cpp",
      }

      libdirs { dirLib .. "**"}
    
      configuration "debug"
        defines { definesDebug }
        flags { flagsDebug }
    
      configuration "release"
        defines { definesRelease }
        flags { flagsRelease }

      configuration { "debug", "x32" }
        links { "glew32d.lib" }

	    configuration  { "debug", "x64" }
        links { "glew64d.lib" }

	    configuration { "release", "x32" }
        links { "glew32.lib" }     
        
	    configuration  { "release", "x64" }
        links { "glew64.lib" }
end