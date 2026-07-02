import sys, os, re
sys.stdout.reconfigure(encoding='utf-8')

ctrl_dir = 'src/main/java/com/hospital/indicator/controller'
for root, dirs, files in os.walk(ctrl_dir):
    for f in sorted(files):
        if not f.endswith('.java'):
            continue
        path = os.path.join(root, f)
        content = open(path, encoding='utf-8', errors='replace').read()
        cm = re.search(r'@RequestMapping\(["\'](.*?)["\']\)', content)
        base = cm.group(1) if cm else ''
        tag = re.search(r'@Tag\(name\s*=\s*"(.*?)"', content)
        tag_name = tag.group(1) if tag else ''
        print(f'\n=== {f} [{tag_name}] base={base} ===')
        for m in re.finditer(r'@(Get|Post|Put|Delete|Patch)Mapping\("([^"]*)"\)', content):
            verb = m.group(1).upper()
            sub  = m.group(2)
            print(f'  {verb:6} {base}{sub}')
