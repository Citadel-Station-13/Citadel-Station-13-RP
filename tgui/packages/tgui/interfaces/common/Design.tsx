
export interface Design {
  name: string;
  desc: string;
  materials?: Record<string, number>;
  material_parts?: Record<string, number>;
  reagents?: Record<string, number>;
  resultItem: DesignItem;
  id: string;
}

export interface DesignItem {
  name?: string;
  desc?: string;
  iconSheet?: string;
  iconPath?: string; // direct access if sheet not provided, if sheet provided we use the spritesheet
}

