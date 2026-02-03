import sys
import buildozer.scripts.client

# Патчируем check_root
original_init = buildozer.Buildozer.__init__

def patched_init(self, *args, **kwargs):
    original_init(self, *args, **kwargs)
    self.check_root = lambda: None

buildozer.Buildozer.__init__ = patched_init

# Запускаем
buildozer.scripts.client.main()
