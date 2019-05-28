import 'child_process' for exec

const stdout: string, stderr = await exec('df -k')