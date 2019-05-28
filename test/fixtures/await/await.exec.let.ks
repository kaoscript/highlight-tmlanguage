import 'child_process' for exec

let stdout: string, stderr = await exec('df -k')