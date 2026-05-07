#run, stallable {

    //module_path := "modules/Box2D/";
    module_path := "./";
    c_path := join(module_path, "box2d/");
    c_src_path := join(c_path, "src/");
    include_dir := join(c_path, "include");
    
    set_build_options_dc(.{do_output=false});
    root_options := get_build_options();
    args := root_options.compile_time_command_line;
        
    compile_release := array_find(args, "-release");

    success := true;

    #if OS == .WINDOWS {

        build_dir := join(module_path, "windows/");
        compile := !has_files_with_extension(build_dir, ".lib");

        if compile {

            make_directory_if_it_does_not_exist(build_dir);
            lib_dir := join(build_dir, "Box2D.static");

            src_files: [..] string;
            add_files_to_compile(c_src_path, *src_files);
            assert(src_files.count > 0);
            success &&= build_cpp_static_lib(lib_dir, ..src_files, extra=.[join("-I", include_dir), "/std:c11"], debug=!compile_release);
        }
    }

    assert(success);

    {
        using opts: Generate_Bindings_Options;
        array_add(*libraries, .{filename="box2d"});
        files := file_list(tprint("%box2d/include", #filepath), true);
        for file: files {
            array_add(*source_files, file);
        }
        array_add(*extra_clang_arguments, "-x", "c++", "-DWIN32_LEAN_AND_MEAN", join("-I", include_dir));
        generate_bindings(opts, "module.jai");
    }

}

#scope_file

add_files_to_compile :: (dir: string, file_list: *[..] string) {
    visitor :: (info : *File_Visit_Info, file_list: *[..] string) {
        if info.is_directory return;
        if contains(info.full_name, ".c") {
            array_add(file_list, info.full_name);
        }
    }
    visit_files(dir, recursive = false, file_list, visitor);
}

has_files_with_extension :: (dir: string, extension: string) -> bool #expand {
    success := false;
    visitor :: (info : *File_Visit_Info, should: *bool) {
        if info.is_directory return;
        if contains(info.full_name, extension) {
            should.* = true;
        }
    }
    visit_files(dir, recursive = false, *success, visitor);
    return success;
}

#import "Basic";
#import "Compiler";
#import "File";
#import "File_Utilities";
#import "BuildCpp";
#import "String";
#import "Bindings_Generator";