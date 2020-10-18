/* Set platform defines at build time for volk to pick up. */
#if defined(_WIN32)
#   define VK_USE_PLATFORM_WIN32_KHR
#elif defined(__linux__) || defined(__unix__)
#   define VK_USE_PLATFORM_XLIB_KHR
#elif defined(__APPLE__)
#   define VK_USE_PLATFORM_MACOS_MVK
#else
#   error "Platform not supported by this example."
#endif

#define VOLK_IMPLEMENTATION
#include "../libs/volk/volk.h"
//#include <volk.h>

#include "../include/hello.hxx"     // header in local directory

using namespace hello;

int main(int argc, char *argv[]) {
  std::cout << "Hello World !" << '\n';

//CPP17 call, to make sure compiler can compile in CPP17
  for(auto &file : std::filesystem::recursive_directory_iterator("./")) {
     std::cout << file.path() << '\n';
  }
  
  const fs::path pathToShow{ argc >= 2 ? argv[1] : fs::current_path() };
  //my_class mc;
  //mc.DisplayPathInfo(pathToShow);
//---------------------

// Volk 
    VkResult r;
    uint32_t version;
    void* ptr;

    /* This won't compile if the appropriate Vulkan platform define isn't set. */
    ptr = 
#if defined(_WIN32)
    &vkCreateWin32SurfaceKHR;
#elif defined(__linux__) || defined(__unix__)
    &vkCreateXlibSurfaceKHR;
#elif defined(__APPLE__)
    &vkCreateMacOSSurfaceMVK;
#else
    /* Platform not recogized for testing. */
    NULL;
#endif

    /* Try to initialize volk. This might not work on CI builds, but the
     * above should have compiled at least. */
    r = volkInitialize();
    if (r != VK_SUCCESS) {
        printf("volkInitialize failed!\n");
        return -1;
    }

    version = volkGetInstanceVersion();
    printf("Vulkan version %d.%d.%d initialized.\n",
            VK_VERSION_MAJOR(version),
            VK_VERSION_MINOR(version),
            VK_VERSION_PATCH(version));

    return 0;
}
