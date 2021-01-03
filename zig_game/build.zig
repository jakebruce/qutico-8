const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
  const mode = b.standardReleaseOptions();

  // Make an executable output
  const exe = b.addExecutable("zig-game", "game.zig");
  exe.setBuildMode(mode);
  exe.linkSystemLibrary("SDL2");
  // exe.linkSystemLibrary("c");
  exe.install();

  // Make a build command that runs the game
  const run_cmd = exe.run();
  run_cmd.step.dependOn(b.getInstallStep());
  const run_step = b.step("run", "Run the game");
  run_step.dependOn(&run_cmd.step);
}
