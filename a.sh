echo ::set-output name=version::$(cat pubspec.yaml | grep version | head -1 | awk '{print $2}' | sed "s/\'//g" | cut -f1 -d"+")
