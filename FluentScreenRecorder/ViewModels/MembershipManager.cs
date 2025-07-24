using SimpleRecorder.Models;
using System;
using System.ComponentModel;
using Windows.Storage;

namespace SimpleRecorder.ViewModels
{
    public class MembershipManager : INotifyPropertyChanged
    {
        private MembershipInfo _currentMembership;
        private readonly ApplicationDataContainer _localSettings;

        public event PropertyChangedEventHandler PropertyChanged;

        public MembershipManager()
        {
            _localSettings = ApplicationData.Current.LocalSettings;
            LoadMembershipInfo();
        }

        public MembershipInfo CurrentMembership
        {
            get => _currentMembership;
            private set
            {
                _currentMembership = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(CurrentMembership)));
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(IsFreeMember)));
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(IsPremiumMember)));
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(IsProfessionalMember)));
            }
        }

        public bool IsFreeMember => CurrentMembership.Type == MembershipType.Free;
        public bool IsPremiumMember => CurrentMembership.Type == MembershipType.Premium && CurrentMembership.IsActive;
        public bool IsProfessionalMember => CurrentMembership.Type == MembershipType.Professional && CurrentMembership.IsActive;

        public bool CanUseFeature(string featureName)
        {
            return featureName switch
            {
                "HighQuality" => MembershipFeatures.CanUseHighQuality(CurrentMembership.Type) && CurrentMembership.IsActive,
                "4K" => MembershipFeatures.CanUse4K(CurrentMembership.Type) && CurrentMembership.IsActive,
                "WatermarkRemoval" => MembershipFeatures.CanUseWatermarkRemoval(CurrentMembership.Type) && CurrentMembership.IsActive,
                "CloudStorage" => MembershipFeatures.CanUseCloudStorage(CurrentMembership.Type) && CurrentMembership.IsActive,
                _ => false
            };
        }

        public int GetMaxRecordingLength()
        {
            if (!CurrentMembership.IsActive && CurrentMembership.Type != MembershipType.Free)
                return MembershipFeatures.GetMaxRecordingLength(MembershipType.Free);
            
            return MembershipFeatures.GetMaxRecordingLength(CurrentMembership.Type);
        }

        public void UpgradeMembership(MembershipType type, int durationMonths)
        {
            CurrentMembership = new MembershipInfo
            {
                Type = type,
                ExpiryDate = DateTime.Now.AddMonths(durationMonths)
            };
            SaveMembershipInfo();
        }

        private void LoadMembershipInfo()
        {
            try
            {
                var typeValue = _localSettings.Values["MembershipType"];
                var expiryValue = _localSettings.Values["MembershipExpiry"];

                if (typeValue != null && expiryValue != null)
                {
                    CurrentMembership = new MembershipInfo
                    {
                        Type = (MembershipType)(int)typeValue,
                        ExpiryDate = DateTime.Parse(expiryValue.ToString())
                    };
                }
                else
                {
                    CurrentMembership = new MembershipInfo
                    {
                        Type = MembershipType.Free,
                        ExpiryDate = DateTime.MaxValue
                    };
                }
            }
            catch
            {
                CurrentMembership = new MembershipInfo
                {
                    Type = MembershipType.Free,
                    ExpiryDate = DateTime.MaxValue
                };
            }
        }

        private void SaveMembershipInfo()
        {
            _localSettings.Values["MembershipType"] = (int)CurrentMembership.Type;
            _localSettings.Values["MembershipExpiry"] = CurrentMembership.ExpiryDate.ToString();
        }
    }
}