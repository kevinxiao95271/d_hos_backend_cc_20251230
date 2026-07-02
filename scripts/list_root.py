import os, sys
sys.stdout.reconfigure(encoding='utf-8')
root = r'd:\iCode\cursor\d_hos_backend_cc_20251230'
for f in sorted(os.listdir(root)):
    full = os.path.join(root, f)
    tag = '[DIR]' if os.path.isdir(full) else '[FILE]'
    print(tag, f)
