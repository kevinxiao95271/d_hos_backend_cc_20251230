import sys, os
sys.stdout.reconfigure(encoding='utf-8')

for d in ['evaluation_indicator_deliverables', 'docs', 'src/main/java/com/hospital/indicator/controller']:
    full = r'd:\iCode\cursor\d_hos_backend_cc_20251230\{}'.format(d)
    print(f'\n=== {d} ===')
    try:
        for f in sorted(os.listdir(full)):
            print(' ', f)
    except Exception as e:
        print(' ERROR:', e)
