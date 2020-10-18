// Typically, header files have an include guard or a #pragma once directive,
//      to ensure that they are not inserted multiple times into a single .cpp file.
//
// include guard type will look like this :
//#ifndef MY_CLASS_H 
//#define MY_CLASS_H
// ...... codes ......
//#endif /* MY_CLASS_H */

#pragma once // include guard

#include <iostream>    // for output
#include <filesystem>  // header in standard library

namespace fs = std::filesystem;

namespace hello
{
	class my_class 
        {
	  public:
		// example adapted from https://docs.microsoft.com/fr-fr/cpp/standard-library/file-system-navigation?view=vs-2019
		void DisplayPathInfo(const fs::path& pathToShow)
		{
			int i = 0;	
			std::cout << "Displaying path info for: " << pathToShow << "\n";
			for (const auto& part : pathToShow)
			{
				std::cout << "path part: " << i++ << " = " << part << "\n";
			}

			std::cout << "exists() = " << fs::exists(pathToShow) << "\n"
				<< "root_name() = " << pathToShow.root_name() << "\n"
				<< "root_path() = " << pathToShow.root_path() << "\n"
				<< "relative_path() = " << pathToShow.relative_path() << "\n"
				<< "parent_path() = " << pathToShow.parent_path() << "\n"
				<< "filename() = " << pathToShow.filename() << "\n"
				<< "stem() = " << pathToShow.stem() << "\n"
				<< "extension() = " << pathToShow.extension() << "\n";

			try
			{
				std::cout << "canonical() = " << fs::canonical(pathToShow) << "\n";
			}
			catch (fs::filesystem_error err)
			{
				std::cout << "exception: " << err.what() << "\n";
			}
		};

	};
}
