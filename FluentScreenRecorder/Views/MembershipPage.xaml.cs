using SimpleRecorder.Models;
using System;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;

namespace SimpleRecorder.Views
{
    public sealed partial class MembershipPage : Page
    {
        public MembershipPage()
        {
            this.InitializeComponent();
        }

        private void BackButton_Click(object sender, RoutedEventArgs e)
        {
            if (Frame.CanGoBack)
            {
                Frame.GoBack();
            }
        }

        private async void PremiumButton_Click(object sender, RoutedEventArgs e)
        {
            // 这里可以集成真实的支付系统
            // 目前模拟升级到高级会员
            App.Membership.UpgradeMembership(MembershipType.Premium, 1); // 1个月

            ContentDialog successDialog = new ContentDialog
            {
                Title = "升级成功！",
                Content = "恭喜您成功升级为高级会员！现在可以享受无限时长录制、1080P超清画质等专业功能。",
                CloseButtonText = "开始体验"
            };

            await successDialog.ShowAsync();

            if (Frame.CanGoBack)
            {
                Frame.GoBack();
            }
        }

        private async void ProfessionalButton_Click(object sender, RoutedEventArgs e)
        {
            // 这里可以集成真实的支付系统
            // 目前模拟升级到专业会员
            App.Membership.UpgradeMembership(MembershipType.Professional, 1); // 1个月

            ContentDialog successDialog = new ContentDialog
            {
                Title = "升级成功！",
                Content = "恭喜您成功升级为专业会员！现在可以享受4K超高清录制、云端存储、批量处理等全部专业功能。",
                CloseButtonText = "开始体验"
            };

            await successDialog.ShowAsync();

            if (Frame.CanGoBack)
            {
                Frame.GoBack();
            }
        }
    }
}