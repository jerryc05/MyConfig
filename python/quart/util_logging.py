import logging
from MyLogFmt import MyLogFmt

logging.basicConfig(level=logging.INFO)
for x in logging.getLogger().handlers:
    x.setFormatter(MyLogFmt())
