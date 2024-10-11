import { SlotId } from "../../models/Model";
import { ModeType } from "../from/SelectorList";
import { ZPRowConfig, ZPRowMode, ZPSection } from "../from/ZPForm";

@Component
export struct SlotSelector {
  @Link slotIds: SlotId[];
  header?: string;
  title?: string;
  valueChanged?: (value: ModeType|boolean|string) => void;

  build() {
    ZPSection({
      header: this.header,
      configs: [
      new ZPRowConfig()
        .mode(ZPRowMode.Selector)
        .datas(this.slotIds.map((item, index) => {
          let value: ModeType = { id: index, name: item.name, value: item.adSlotId }
          return value
        }))
        .value(0)
        .onValueChanged(this.valueChanged),
      ]
    })
  }
}