using System;
using System.Globalization;
using System.Windows.Data;

namespace ProjectEye.Resources.Converters
{
    /// <summary>
    /// 枚举值到索引的转换器
    /// </summary>
    public class EnumToIndexConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null) return 0;
            
            if (value is Enum enumValue)
            {
                return (int)enumValue;
            }
            
            return 0;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is int index && targetType.IsEnum)
            {
                return Enum.ToObject(targetType, index);
            }
            
            return Enum.ToObject(targetType, 0);
        }
    }
}