# Goto %LOCALAPPDATA%\DeadByDaylight\Saved\Config\WindowsNoEditor\

# Open Engine.ini

# Add/modify lines:

MAX_FPS = 170
f'''
[/script/engine.engine]
bSmoothFrameRate=false
MinSmoothedFrameRate=5
MaxSmoothedFrameRate={MAX_FPS}
bUseVsync=false
'''

# Open GameUserSettings.ini

# Modify lines:
'''
bUseVSync=False
'''
