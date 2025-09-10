namespace ProjectEye.Core.Enums
{
    /// <summary>
    /// 锁屏时的行为模式
    /// </summary>
    public enum ScreenLockBehavior
    {
        /// <summary>
        /// 不做任何处理，继续计时
        /// </summary>
        ContinueTimer = 0,
        
        /// <summary>
        /// 暂停计时器，解锁后恢复
        /// </summary>
        PauseTimer = 1,
        
        /// <summary>
        /// 暂停并重置计时器，解锁后重新开始计时
        /// </summary>
        PauseAndResetTimer = 2
    }
}