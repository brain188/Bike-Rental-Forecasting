import sys
import os
from pathlib import Path

# Add project root to path
project_root = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(project_root / "src"))

from app_ui.app import app

if __name__ == "__main__":
    port = int(os.getenv("PORT", 8050))

    app.run(debug=False, host="0.0.0.0", port=port)