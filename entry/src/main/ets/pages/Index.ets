import Constant from '../common/Constant'
import { NavigationBarView } from '../components/navigation/NavigationBarView'
import { NavigationView } from '../components/navigation/NavigationView'
import { TitleComponent } from '../components/views/TitleComponent'
import { IndexData, IndexViewModel } from '../viewModels/IndexViewModel'
import router from '@ohos.router'

@Entry
@Component
struct Index {
  private viewModel = new IndexViewModel();

  build() {
    Stack() {
      NavigationView({
        navigationBuilder: () => {
          this.navigationBuilder()
        },
        contentBuilder: () => {
          this.contentBuilder()
        }
      })
        .width('100%').height('100%')
    }.width('100%').height('100%')
  }

  @Builder
  navigationBuilder() {
    NavigationBarView({
      title: 'ToBid聚合广告',
      showBack: false,
      naviBackgroundColor: $r('app.color.main_color'),
    })
  }

  @Builder
  contentBuilder() {
    List() {
      ForEach(this.viewModel.datas(), (data: IndexData) => {
        ListItem() {
          TitleComponent({
            title: data.title,
            icon: data.icon,
            rowType: data.rowType,
            value: data.value
          })
        }.onClick(() => {
          router.pushUrl({
            url: data.url,
            params: data.title
          })
        })
        .margin({
          top: $r('app.float.padding_normal'),
          bottom: $r('app.float.padding_normal')
        })
      })
    }
    .width(Constant.FULL_PARENT)
    .height(Constant.FULL_PARENT)
  }
}