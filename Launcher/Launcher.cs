using System;
using System.Diagnostics;
using System.IO;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SimpleRecorderLauncher
{
    class Program
    {
        [STAThread]
        static void Main(string[] args)
        {
            try
            {
                // 尝试启动UWP应用
                LaunchUWPApp();
            }
            catch (Exception ex)
            {
                // 如果启动失败，显示错误信息
                MessageBox.Show($"无法启动极简录屏应用：\n\n{ex.Message}\n\n请尝试重新安装应用。", 
                               "极简录屏 - 启动失败", 
                               MessageBoxButtons.OK, 
                               MessageBoxIcon.Error);
            }
        }

        static void LaunchUWPApp()
        {
            try
            {
                // 方法1: 通过协议启动
                Process.Start(new ProcessStartInfo
                {
                    FileName = "explorer.exe",
                    Arguments = "shell:AppsFolder\\SimpleRecorder.App_8wekyb3d8bbwe!App",
                    UseShellExecute = true
                });
            }
            catch
            {
                try
                {
                    // 方法2: 通过PowerShell启动
                    var psi = new ProcessStartInfo
                    {
                        FileName = "powershell.exe",
                        Arguments = "-Command \"Get-AppxPackage | Where-Object {$_.Name -like '*SimpleRecorder*'} | Invoke-CommandInDesktopPackage -Command 'SimpleRecorder.exe'\"",
                        UseShellExecute = false,
                        CreateNoWindow = true
                    };
                    Process.Start(psi);
                }
                catch
                {
                    // 方法3: 提示用户手动启动
                    var result = MessageBox.Show(
                        "无法自动启动应用。\n\n是否要打开应用安装位置？",
                        "极简录屏",
                        MessageBoxButtons.YesNo,
                        MessageBoxIcon.Question);

                    if (result == DialogResult.Yes)
                    {
                        Process.Start("explorer.exe", "shell:AppsFolder");
                    }
                }
            }
        }
    }
}