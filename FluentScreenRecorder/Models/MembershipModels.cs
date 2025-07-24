using System;

namespace SimpleRecorder.Models
{
    public enum MembershipType
    {
        Free = 0,
        Premium = 1,
        Professional = 2
    }

    public class MembershipInfo
    {
        public MembershipType Type { get; set; }
        public DateTime ExpiryDate { get; set; }
        public bool IsActive => DateTime.Now < ExpiryDate;
        public string DisplayName => Type switch
        {
            MembershipType.Free => "免费版",
            MembershipType.Premium => "高级会员",
            MembershipType.Professional => "专业会员",
            _ => "未知"
        };
    }

    public class MembershipFeatures
    {
        public static bool CanUseHighQuality(MembershipType type) => type != MembershipType.Free;
        public static bool CanUse4K(MembershipType type) => type == MembershipType.Professional;
        public static bool CanUseWatermarkRemoval(MembershipType type) => type != MembershipType.Free;
        public static bool CanUseCloudStorage(MembershipType type) => type == MembershipType.Professional;
        public static int GetMaxRecordingLength(MembershipType type) => type switch
        {
            MembershipType.Free => 10, // 10分钟
            MembershipType.Premium => 120, // 2小时
            MembershipType.Professional => int.MaxValue, // 无限制
            _ => 10
        };
    }

    public class MembershipPrice
    {
        public MembershipType Type { get; set; }
        public decimal MonthlyPrice { get; set; }
        public decimal YearlyPrice { get; set; }
        public string[] Features { get; set; }
    }
}