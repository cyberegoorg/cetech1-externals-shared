const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    //
    // Sync remote repository
    //
    const sync_remote_step = b.step("sync-remote", "Upgrade repositories in repo folder");
    const sync_remote_submodules = b.addSystemCommand(&.{
        "git",

        // FIXME: skip zls (we need stay on specific commit for compatibility)
        //"-c",
        //"submodule.\"repo/zls\".update=none",

        "submodule",
        "update",
        "--init",
        "--remote",
    });
    sync_remote_step.dependOn(&sync_remote_submodules.step);

    //
    // Sync local
    //
    const sync_local_step = b.step("sync-local", "Copy files from repo to lib");
    const copy_tool = b.addExecutable(.{
        .name = "copy",
        .root_source_file = b.path("src/copy.zig"),
        .target = target,
        .optimize = optimize,
    });
    const copy_run = b.addRunArtifact(copy_tool);
    sync_local_step.dependOn(&copy_run.step);
}
