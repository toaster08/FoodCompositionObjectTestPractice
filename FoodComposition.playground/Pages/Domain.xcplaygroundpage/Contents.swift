import Foundation
import XCTest
import Darwin

//    static let defaultCategory = ["１ 穀類",
//                                  "２ いも及びでん粉類",
//                                  "３ 砂糖及び甘味類",
//                                  "４ 豆類",
//                                  "5 種実類",
//                                  "6 野菜類",
//                                  "7 果実類",
//                                  "8 きのこ類",
//                                  "9 藻類",
//                                  "10 魚介類",
//                                  "11 肉類",
//                                  "12 卵類",
//                                  "13 乳類",
//                                  "14 油脂類",
//                                  "15 菓子類",
//                                  "16 し好飲料類",
//                                  "17 調味料及び香辛料類",
//                                  "18　調理済み流通食品類"]

enum Composition {
    
    case protein(min:Double?,max:Double?)
    case weight(min:Double?,max:Double?)
    case category(CategoryType)
    
    var nameString: String {
        switch self {
        case .protein: return "たんぱく質"
        case .weight: return "重量"
        case .category: return "カテゴリ"
        }
    }
    
    //CaseIterableを準拠できないのでプロパティとして書き起こす
    static var allCases: [Composition] {
        return [
            .protein(min: nil, max: nil),
            .weight(min: nil, max: nil),
            .category(.kokurui)
        ]
    }
}

enum CategoryType:Int, CaseIterable {
    case kokurui = 0
    case imo
    case satou
    
    var name: String {
        switch self {
        case .kokurui: return "１ 穀類"
        case .imo: return "２ いも及びでん粉類"
        case .satou: return "３ 砂糖及び甘味類"
    //        case .kokurui: return Self.defaultCategory[CategoryType.kokurui.rawValue]
    //        case .imo: return Self.defaultCategory[CategoryType.imo.rawValue]
    //        case .satou: return Self.defaultCategory[CategoryType.satou.rawValue]
        }
    }
    
    func CompositionString(at composition: Composition) -> String {
        composition.nameString
    }
}

enum KetogenicIndexType: Int, CaseIterable {
    case ketogenicRatio
    case ketogenicIndex
    case ketogenicValue
    
    var name: String {
        switch self {
        case .ketogenicRatio: return "ケトン比"
        case .ketogenicIndex: return "ケトン指数"
        case .ketogenicValue: return "ケトン値"
        }
    }
}

//データベースから返ってくる値
struct FoodCompositionRealm {
    var id: Int?
    var protein: Double?
    var fat: Double?
    var carbohydrate: Double?
    var sugar: Double?
    var category: String?
}

//protocol KetogenicIndexTypeProtocol {
//    var protein: Double { get }
//    var fat: Double { get }
//    optional var carbohydrate: Double { get }
//    optional var sugar: Double { get }
//    optional var ratioValue: Double?
//}

//struct KetogenicRatio { // Protein Fat Carbohydrate
//
//    var protein: Double
//    var fat: Double
//    var carbohydrate: Double
//
//    var ratioValue: Double? {  // ケトン比の算出
//        if (protein + carbohydrate) == 0 { return nil }
//        return fat / (protein + carbohydrate)
//    }
//
//    //Tableからのイニシャライズ
//    init(food: FoodComposition){
//        protein = food.protein
//        fat = food.fat
//        carbohydrate = food.carbohydrate
//    }
//
//    //UIからのイニシャライズ
//    init(protein: Double, fat: Double, carbohydrate: Double) {
//        self.protein = protein
//        self.fat = fat
//        self.carbohydrate = carbohydrate
//    }
//
//    // 目標ケトン比に対する必要脂質量の過不足
//    func addLipidRequirement(for targetValue: Double) -> Double? {
//        guard let ratioValue = ratioValue else { return nil}
//        return (targetValue - ratioValue) * (protein + carbohydrate)
//    }
//}
//
//struct KetogenicIndex { // Protein Fat Carbohydrate
//
//    var protein: Double
//    var fat: Double
//    var carbohydrate: Double
//
//    var indexValue: Double? { // ケトン指数の算出
//        if (carbohydrate + 0.1 * fat + 0.58 * protein) == 0 { return nil }
//        return (0.9 * fat + 0.46 * protein) / (carbohydrate + 0.1 * fat + 0.58 * protein)
//    }
//
//    //Tableからのイニシャライズ
//    init(food: FoodComposition){
//        protein = food.protein
//        fat = food.fat
//        carbohydrate = food.carbohydrate
//    }
//
//    //UIからのイニシャライズ
//    init(protein: Double, fat: Double, carbohydrate: Double) {
//        self.protein = protein
//        self.fat = fat
//        self.carbohydrate = carbohydrate
//    }
//
//    // 目標ケトン比に対する必要脂質量の過不足
//    func addLipidRequirement(for targetValue: Double) -> Double? {
//        if ((0.1 * targetValue - 0.9) - fat) == 0 { return nil }
//        return (0.46 * protein - targetValue * ( carbohydrate + 0.58 * protein)) / ( 0.1 * targetValue - 0.9) - fat
//    }
//}
//
//struct KetogenicValue { // Protein Fat Sugar
//
//    var protein: Double
//    var fat: Double
//    var sugar: Double
//
//    var valueValue: Double? {
//        if (sugar + 0.1 * fat + 0.58 * protein) == 0 { return nil }
//        return (0.9 * fat + 0.46 * protein) / (sugar + 0.1 * fat + 0.58 * protein)
//    }
//
//    //Tableからのイニシャライズ
//    init(food: FoodComposition){
//        protein = food.protein
//        fat = food.fat
//        sugar = food.sugar
//    }
//
//    //UIからのイニシャライズ
//    init(protein: Double, fat: Double, sugar: Double) {
//        self.protein = protein
//        self.fat = fat
//        self.sugar = sugar
//    }
//
//    // 目標ケトン値に対する必要脂質量の過不足
//    func addLipidRequirement(for targetValue: Double) -> Double? {
//        if ((0.1 * targetValue - 0.9) - fat) == 0 { return nil }
//        return (0.46 * protein - targetValue * ( sugar + 0.58 * protein )) / (0.1 * targetValue - 0.9) - fat
//    }
//}
//
//class KetonBodyUseCase {
//}
//ベースはTable
//利用するためのModel
//Ketoneのためじゃなくて合計ではない計算をさせることにおいてはここを通す
struct PFC { // Protein Fat Carbohydrate
    
    var protein: Double
    var fat: Double
    var carbohydrate: Double
    var energy: Double { // Atwaterの係数
        (protein * 4)
        + (fat * 9)
        + (carbohydrate * 4)
    }
    
    var proteinPercentEnergy: Double {
        (( protein * 4) / energy ) * 100
    }
    
    var fatPercentEnergy: Double {
        (( fat * 9) / energy ) * 100
    }
    
    var carbohydratePercentEnergy: Double {
        (( carbohydrate * 4) / energy ) * 100
    }
    
    var ketogenicRatio: Double? {  // ケトン比の算出
        if (protein + carbohydrate) == 0 { return nil }
        let index = fat / (protein + carbohydrate)
        let roundedIndex = round(index * 10) / 10
        return roundedIndex
    }
    
    var ketogenicIndex: Double? { // ケトン指数の算出
        if (carbohydrate + 0.1 * fat + 0.58 * protein) == 0 { return nil }
        let index =  (0.9 * fat + 0.46 * protein) / (carbohydrate + 0.1 * fat + 0.58 * protein)
        let roundedIndex = round(index * 10) / 10
        return roundedIndex
    }
    
    //Tableからのイニシャライズ
    init(food: FoodComposition){
        protein = food.protein
        fat = food.fat
        carbohydrate = food.carbohydrate
    }
    
    //UIからのイニシャライズ
    init(protein: Double, fat: Double, carbohydrate: Double) {
        self.protein = protein
        self.fat = fat
        self.carbohydrate = carbohydrate
    }
    
    // 目標ケトン比に対する必要脂質量の過不足
    func lipidRequirementInKetogenicRatio(for targetValue: Double) -> Double? {
        guard let ketogenicRatio = ketogenicRatio else { return nil}
        let lipidRequirement = (targetValue - ketogenicRatio) * (protein + carbohydrate)
        let roundedLipidRequirement = round(lipidRequirement * 10) / 10
        return roundedLipidRequirement
    }
    
    // 目標ケトン指数に対する必要脂質量の過不足
    func lipidRequirementInKetogenicIndex(for targetValue: Double) -> Double? {
        if ((0.1 * targetValue - 0.9) - fat) == 0 { return nil }
        let lipidRequirement = (0.46 * protein - targetValue * ( carbohydrate + 0.58 * protein)) / ( 0.1 * targetValue - 0.9) - fat
        let roundedLipidRequirement = round(lipidRequirement * 10) / 10
        return roundedLipidRequirement
        
    }
}

//PFCに関することは集約
//エネルギー計算やケトン比
//どちらかというとUseCaseのような役割かもしれない
//食品から計算に利用するような機能はここに集約させる
struct PFS { // Protein Fat Sugar
    
    var protein: Double
    var fat: Double
    var sugar: Double
    
    //Enerygy関係はほとんど同様のプロパティがPFSとPFCと二箇所にあって良くない
    var energy: Double { // Atwater
        (protein * 4)
        + (fat * 9)
        + (sugar * 4)
    }
    
    var proteinPercentEnergy: Double {
        (( protein * 4) / energy ) * 100
    }
    
    var fatPercentEnergy: Double {
        (( fat * 9) / energy ) * 100
    }
    
    var sugarPercentEnergy: Double {
        (( sugar * 4) / energy ) * 100
    }
    
    var ketogenicValue: Double? {
        if (sugar + 0.1 * fat + 0.58 * protein) == 0 { return nil }
        let index =  (0.9 * fat + 0.46 * protein) / (sugar + 0.1 * fat + 0.58 * protein)
        let roundedIndex = round(index * 10) / 10
        return roundedIndex
    }
    
    //Tableからのイニシャライズ
    init(food: FoodComposition){
        protein = food.protein
        fat = food.fat
        sugar = food.sugar
    }
    
    //UIからのイニシャライズ
    init(protein: Double, fat: Double, sugar: Double) {
        self.protein = protein
        self.fat = fat
        self.sugar = sugar
    }
    
    // 目標ケトン値に対する必要脂質量の過不足
    func lipidRequirementInKetogenicValue(for targetValue: Double) -> Double? {
        if ((0.1 * targetValue - 0.9) - fat) == 0 { return nil }
        let lipidRequirement = (0.46 * protein - targetValue * ( sugar + 0.58 * protein )) / (0.1 * targetValue - 0.9) - fat
        let roundedLipidRequirement = round(lipidRequirement * 10) / 10
        return roundedLipidRequirement
    }
}

//Modelとして利用する値
struct FoodComposition: Equatable {
    
    var id: Int?
    var protein: Double
    var fat: Double
    var carbohydrate: Double
    var sugar: Double
    var category: String
    var weight:Double = 100.0
    
    init(food: FoodCompositionRealm) {
        //これがOKなのかどうか
        self.id = food.id ?? UUID().hashValue
        self.protein = food.protein ?? 0
        self.fat = food.fat ?? 0
        self.carbohydrate = food.carbohydrate ?? 0
        self.sugar = food.sugar ?? 0
        self.category = food.category ?? ""
    }
}

struct SelectFood {
    let food: FoodComposition
    let weight: Double
}

//Tableの単純な合計等
class FoodTableUseCase {
    
    var selectedFoods: [FoodComposition] = []
    
    //TODO: selectedFoods -> userSelectFoods へ変更
    var userSelectFoods: [SelectFood] = []
    
    //選んだ食品数 ApplicationService
    var totalSelectedFoodCount: Int {
        selectedFoods.count
    }
    
    //DomainService
    var totalProtein: Double {
        selectedFoods.reduce(0) { totalProtein, food in
            let protein = food.protein
            return totalProtein + protein
        }
    }
    
    var totalWeight: Double {
        selectedFoods.reduce(0) { totalWeight, food in
            let weight = food.weight
            return totalWeight + weight
        }
    }
    
    func add(food: FoodComposition, to foodList:[FoodComposition])  -> [FoodComposition] {
        var foodList = foodList
        foodList.append(food)
        return foodList
    }

    func delete(food: FoodComposition, from foodList: [FoodComposition]) -> [FoodComposition]{
        var foodList = foodList
        for i in 0...(foodList.count - 1) {
            if foodList[i].id == food.id {
                foodList.remove(at: i)
                print(foodList)
                return foodList
            }
        }
        return foodList
    }
    
//    func add(food: FoodComposition) {
//        //副作用のある関数
//        selectedFoods.append(food)
//    }
//
//    func delete(food: FoodComposition) {
//        //副作用のある関数
//        for i in 0...(selectedFoods.count - 1) {
//            if selectedFoods[i].id == food.id {
//                selectedFoods.remove(at: i)
//            }
//        }
//    }
}

extension Array where Element == FoodComposition {
    
    func filterFoods(by composition: Composition) -> [FoodComposition] {
        
        var filetedFoods: [FoodComposition] = []
        switch composition {
        case .protein(let min, let max):
            filetedFoods = self.filter {
                guard let min = min , let max = max else { return false }
                return $0.protein >= min && $0.protein <= max
            }
        case .weight(let min, let max):
            filetedFoods = self.filter {
                guard let min = min, let max = max else { return false }
                return $0.weight >= min && $0.weight <= max
            }
        case .category(let category):
            filetedFoods = self.filter {
                let categoryName = category.name
                return $0.category == categoryName
            }
        }
        
        return filetedFoods
    }
    
    
    func sortedFoods(by composition: Composition) -> [FoodComposition] {
        //昇順
        switch composition {
        case .protein: return self.sorted { $0.protein > $1.protein }
        case .weight:  return self.sorted { $0.weight > $1.weight }
        case .category: return self
        }
    }
}


//イニシャライズ
class FoodTableUseCaseTest: XCTestCase {
    
    static let testFoods = [
        FoodComposition(food: FoodCompositionRealm(id: 1,
                                                   protein: 20,
                                                   category: "１ 穀類")),
        FoodComposition(food: FoodCompositionRealm(id: 2,
                                                   protein: 30,
                                                   category: "２ いも及びでん粉類")),
        FoodComposition(food: FoodCompositionRealm(id: 3,
                                                   protein: 40,
                                                   category: "２ いも及びでん粉類")),
        FoodComposition(food: FoodCompositionRealm(id: 4,
                                                   protein: 50,
                                                   category: "18　調理済み流通食品類")),
        FoodComposition(food: FoodCompositionRealm(id: 5,
                                                   protein: 60,
                                                   category: "１ 穀類")),
        FoodComposition(food: FoodCompositionRealm(id: 6,
                                                   protein: 70,
                                                   category: "18　調理済み流通食品類")),
        FoodComposition(food: FoodCompositionRealm(id: 7,
                                                   protein: 20,
                                                   category: "１ 穀類"))
    ]

    
    let foodTableUseCase = FoodTableUseCase()
    
    let food =  FoodComposition(food: FoodCompositionRealm(id: 2,
                                                           protein: 1,
                                                           category: ""))
    
    //nonEffected
    let testFoods = [
        FoodComposition(food: FoodCompositionRealm(id: 1,
                                                   protein: 20,
                                                   category: "１ 穀類")),
        FoodComposition(food: FoodCompositionRealm(id: 2,
                                                   protein: 40,
                                                   category: "２ いも及びでん粉類")),
        FoodComposition(food: FoodCompositionRealm(id: 3,
                                                   protein: 100,
                                                   category: "２ いも及びでん粉類"))
    ]
    
    func test_配列に含まれた食品総数の算出(){
        
        foodTableUseCase.selectedFoods = testFoods
        
        let totalFoodsCount = foodTableUseCase.totalSelectedFoodCount
        XCTAssertEqual(totalFoodsCount, testFoods.count, "配列の要素数と食品総数の値が一致")
    }
    
    func test_ケトン比の算出() {
        //状態
        let pfc = PFC(protein: 1, fat: 4, carbohydrate: 1)
        //操作?
        let ketogenicRatio = pfc.ketogenicRatio
        //検証
        let expected = 2.0
        
        XCTAssertEqual(ketogenicRatio, expected)
    }
    
    func test_ケトン指数の算出() {
        //状態
        let pfc = PFC(protein: 1, fat: 4, carbohydrate: 1)
        //操作？
        let ketogenicIndex = pfc.ketogenicIndex
        //検証
        let expected = 2.1
        
        XCTAssertEqual(ketogenicIndex, expected)
    }
    //
    func test_ケトン値の算出() {
        //状態
        let pfs = PFS(protein: 1, fat: 7.1, sugar: 1)
        //操作？
        let ketogenicValue = pfs.ketogenicValue
        //検証
        let expected = 3.0
        
        XCTAssertEqual(ketogenicValue, expected)
    }
    //
    func test_目標ケトン比の必要な脂質量の算出() {
        //状態
        let pfc = PFC(protein: 1, fat: 4, carbohydrate: 1)
        //操作？
        let lipidRequirement = pfc.lipidRequirementInKetogenicRatio(for: 3.0)
        //検証
        let expected = 2.0
        
        XCTAssertEqual(lipidRequirement, expected)
    }
    
    func test_目標ケトン指数の必要な脂質量の算出() {
        //状態
        let pfc = PFC(protein: 1, fat: 4, carbohydrate: 1)
        //操作？
        let lipidRequirement = pfc.lipidRequirementInKetogenicIndex(for: 3.0)
        //検証
        let expected = 3.1
        
        XCTAssertEqual(lipidRequirement, expected)
    }
    
    func test_目標ケトン値の必要な脂質量の算出() {
        //状態
        let pfs = PFS(protein: 1, fat: 4, sugar: 1)
        //操作？
        let lipidRequirement = pfs.lipidRequirementInKetogenicValue(for: 3.0)
        //検証
        let expected = 3.1
        
        XCTAssertEqual(lipidRequirement, expected)
    }
    
    func test_栄養素量_nilでのフィルタリング() {
        //状態

        //操作
        let filterdFoods = testFoods.filterFoods(by: .protein(min: nil, max: nil))
        //検証
        let expected:[FoodComposition] = []
        XCTAssertEqual(filterdFoods, expected)
    }
    
    func test_栄養素量でのフィルタリング() {
        //状態
        
        //操作
        let filterdFoods = testFoods.filterFoods(by: .protein(min: 20, max: 50))
        //検証
        let expected:[FoodComposition] = [
            FoodComposition(food: FoodCompositionRealm(id: 1,
                                                       protein: 20,
                                                       category: "１ 穀類")),
            FoodComposition(food: FoodCompositionRealm(id: 2,
                                                       protein: 40,
                                                       category: "２ いも及びでん粉類")),
        ]
        
        XCTAssertEqual(filterdFoods, expected)
    }
    
    func test_栄養素カテゴリ名でのフィルタリング() {
        //状態
        
        //操作
        let filterdFoods = testFoods.filterFoods(by: .category(.kokurui))
        //検証
        let expected:[FoodComposition] = [
            FoodComposition(food: FoodCompositionRealm(id: 1,
                                                       protein: 20,
                                                       category: "１ 穀類"))
        ]
        
        XCTAssertEqual(filterdFoods, expected)
    }
    
    func test_カテゴリ名によるソート() {
        //状態
        
        //操作
        let sortedSelectFoods = testFoods.sortedFoods(by: .category(.imo))
        //検証
        let expected = testFoods
        
        XCTAssertEqual(sortedSelectFoods, expected)
    }
    
    func test_栄養素名による昇順ソート_引数min_nil_max_nil() {
        //状態
        
        //操作
        let sortedSelectFoods = testFoods.sortedFoods(by: .protein(min: nil, max: nil))
        //検証
        let expected = [
            FoodComposition(food: FoodCompositionRealm(id: 3,
                                                       protein: 100,
                                                       category: "２ いも及びでん粉類")),
            FoodComposition(food: FoodCompositionRealm(id: 2,
                                                       protein: 40,
                                                       category: "２ いも及びでん粉類")),
            FoodComposition(food: FoodCompositionRealm(id: 1,
                                                       protein: 20,
                                                       category: "１ 穀類"))
        ]
        
        XCTAssertEqual(sortedSelectFoods, expected)
    }
    
    func test_栄養素名による昇順ソート() {
        //状態
        
        //操作
        let sortedSelectFoods = testFoods.sortedFoods(by: .protein(min: 20, max: 50))
        //検証
        let expected = [
            FoodComposition(food: FoodCompositionRealm(id: 3,
                                                       protein: 100,
                                                       category: "２ いも及びでん粉類")),
            FoodComposition(food: FoodCompositionRealm(id: 2,
                                                       protein: 40,
                                                       category: "２ いも及びでん粉類")),
            FoodComposition(food: FoodCompositionRealm(id: 1,
                                                       protein: 20,
                                                       category: "１ 穀類"))
        ]
        
        XCTAssertEqual(sortedSelectFoods, expected)
    }
    
    func test_選択された食品一覧へのの追加() {
        //状態

        //操作
        let addedSelectFoodList = foodTableUseCase.add(food: food, to: testFoods)
        //検証
        XCTAssertEqual(addedSelectFoodList.count, testFoods.count + 1)
    }
    
    func test_選択された食品一覧からの削除() {
        //状態

        //操作
        let deletedSelectFoodList = foodTableUseCase.delete(food: food, from: testFoods)
        //検証
        XCTAssertEqual(deletedSelectFoodList.count, testFoods.count - 1)
    }
}

FoodTableUseCaseTest.defaultTestSuite.run()

//let food =  FoodComposition(food: FoodCompositionRealm(id: 13,
//                                                       protein: 1,
//                                                       fat: 1,
//                                                       carbohydrate: 1,
//                                                       sugar: 1,
//                                                       category: ""),
//                            weight: 100)
//foodTableUseCase.add(food: food, to: testFoods)
//foodTableUseCase.totalSelectedFoodCount
//foodTableUseCase.delete(food: food, from: testFoods)
//
////ケトン指標を算出（合計）
//let protein = foodTableUseCase.totalProtein
//let fat = foodTableUseCase.totalProtein
//let carbohydrate = foodTableUseCase.totalProtein
//let sugar = foodTableUseCase.totalProtein
//
//let pfc = PFC(protein: protein, fat: fat, carbohydrate: carbohydrate)
//pfc.ketogenicRatio
//pfc.ketogenicIndex
//pfc.lipidRequirementInKetogenicIndex(for: 3.0)
//
//let pfs = PFS(protein: protein, fat: fat, sugar: sugar)
//pfs.ketogenicValue
//pfs.lipidRequirementInKetogenicValue(for: 3.0)
