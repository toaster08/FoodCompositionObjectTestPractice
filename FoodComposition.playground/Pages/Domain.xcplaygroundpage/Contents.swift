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
    
    case water(min:Double?,max:Double?)
    case energy(min:Int?,max:Int?)
    case protein(min:Double?,max:Double?)
    case fat(min:Double?,max:Double?)
    case dietaryfiber(min:Double?,max:Double?)
    case carbohydrate(min:Double?,max:Double?)
    case category(CategoryType)
    case weight(min:Double?,max:Double?)
    
    
    var nameString: String {
        switch self {
        case .water:  return "水分量"
        case .energy: return "エネルギー量"
        case .protein: return "たんぱく質"
        case .fat: return "脂質量"
        case .dietaryfiber: return "食物繊維"
        case .carbohydrate: return "炭水化物"
        case .category: return "カテゴリ"
        case .weight: return "重量"
        }
    }
    
    //CaseIterableを準拠できないのでプロパティとして書き起こす
    static var allCases: [Composition] {
        return [
            .water(min: nil, max: nil),
            .energy(min: nil, max: nil),
            .protein(min: nil, max: nil),
            .fat(min: nil, max: nil),
            .dietaryfiber(min: nil, max: nil),
            .carbohydrate(min: nil, max: nil),
            .category(.koku),
            .weight(min: nil, max: nil)
        ]
    }
}

enum CategoryType:Int, CaseIterable {
    case koku = 0
    case imo
    case satou
    case mame
    case syuzitsu
    case yasai
    case kazitsu
    case kinoko
    case sou
    case gyokai
    case niku
    case tamago
    case nyuu
    case yushi
    case kashi
    case sikouinryou
    case tyoumiryou
    case tyourizumi
    
    var name: String {
        switch self {
        case .koku: return "１ 穀類"
        case .imo: return "２ いも及びでん粉類"
        case .satou: return "３ 砂糖及び甘味類"
        case .mame: return "４ 豆類"
        case .syuzitsu: return "5 種実類"
        case .yasai: return "6 野菜類"
        case .kazitsu: return "7 果実類"
        case .kinoko: return "8 きのこ類"
        case .sou: return "9 藻類"
        case .gyokai: return "10 魚介類"
        case .niku: return "11 肉類"
        case .tamago: return "12 卵類"
        case .nyuu: return "13 乳類"
        case .yushi: return "14 油脂類"
        case .kashi: return "15 菓子類"
        case .sikouinryou: return "16 し好飲料類"
        case .tyoumiryou: return "17 調味料及び香辛料類"
        case .tyourizumi: return "18　調理済み流通食品類"
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
    var food_code: Int?
    var food_name: String?
    var energy: Int?
    var water: Double?
    var protein: Double?
    var fat: Double?
    var dietaryfiber: Double?
    var carbohydrate: Double?
    var sugar: Double?
    var category: String?
}

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
    var food_code: Int
    var food_name: String
    var energy: Int
    var water: Double
    var protein: Double
    var fat: Double
    var dietaryfiber: Double
    var carbohydrate: Double
    var sugar: Double
    var category: String
    
    var weight:Double = 100.0
    
    init(food: FoodCompositionRealm) {
        //これがOKなのかどうか
        self.id = food.id
        self.food_code = food.food_code ?? 0
        self.food_name = food.food_name ?? ""
        self.energy = food.energy ?? 0
        self.water = food.water ?? 0
        self.protein = food.protein ?? 0
        self.fat = food.fat ?? 0
        self.carbohydrate = food.carbohydrate ?? 0
        self.dietaryfiber = food.dietaryfiber ?? 0
        self.sugar = food.sugar ?? 0
        self.category = food.category ?? ""
    }
}

struct SelectFood {
    let food: FoodComposition
    let weight: Double
}


class FoodTableUseCase {

}

extension Array where Element == FoodComposition {
    
    func filterFoods(by composition: Composition) -> [FoodComposition] {
        
        var filetedFoods: [FoodComposition] = []
        
        switch composition {
        case .energy(min: let min, max: let max):
            filetedFoods = self.filter {
                guard let min = min , let max = max else { return false }
                return $0.energy >= min && $0.energy <= max
            }
        case .water(min: let min, max: let max):
            filetedFoods = self.filter {
                guard let min = min , let max = max else { return false }
                return $0.water >= min && $0.water <= max
            }
        case .protein(let min, let max):
            filetedFoods = self.filter {
                guard let min = min , let max = max else { return false }
                return $0.protein >= min && $0.protein <= max
            }
        case .fat(min: let min, max: let max):
            filetedFoods = self.filter {
                guard let min = min , let max = max else { return false }
                return $0.fat >= min && $0.fat <= max
            }
        case .dietaryfiber(min: let min, max: let max):
            filetedFoods = self.filter {
                guard let min = min , let max = max else { return false }
                return $0.dietaryfiber >= min && $0.dietaryfiber <= max
            }
        case .carbohydrate(min: let min, max: let max):
            filetedFoods = self.filter {
                guard let min = min , let max = max else { return false }
                return $0.carbohydrate >= min && $0.carbohydrate <= max
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
        case .energy: return self.sorted { $0.energy > $1.energy }
        case .water: return self.sorted { $0.water > $1.water }
        case .protein: return self.sorted { $0.protein > $1.protein }
        case .fat: return self.sorted { $0.fat > $1.fat }
        case .dietaryfiber: return self.sorted { $0.dietaryfiber > $1.dietaryfiber }
        case .carbohydrate: return self.sorted { $0.carbohydrate > $1.carbohydrate }
        case .weight:  return self.sorted { $0.weight > $1.weight }
        case .category: return self
        }
    }
}

//Tableの単純な合計等
class SelectFoodTableUseCase {
    
    var selectedFoods: [SelectFood] = []
    
    //TODO: selectedFoods -> userSelectFoods へ変更
    //    var userSelectFoods: [SelectFood] = []
    
    //選んだ食品数 ApplicationService
    var totalSelectedFoodCount: Int {
        selectedFoods.count
    }
    
    //DomainService
    //O(1)である必要がある？
    var totalProtein: Double {
        selectedFoods.reduce(0) { totalProtein, selectfood in
            let protein = selectfood.food.protein * ( selectfood.weight / 100 )
            return totalProtein + protein
        }
    }
    
    var totalFat: Double {
        selectedFoods.reduce(0) { totalFat, selectfood in
            let fat = selectfood.food.fat * ( selectfood.weight / 100 )
            return totalFat + fat
        }
    }
    
    var totalCarbohydrate: Double {
        selectedFoods.reduce(0) { totalCarbohydrate, selectfood in
            let carbohydrate = selectfood.food.carbohydrate * ( selectfood.weight / 100 )
            return totalCarbohydrate + carbohydrate
        }
    }
    
    var totalDietaryFiber: Double {
        selectedFoods.reduce(0) { totalDietaryFiber, selectfood in
            let dietaryFiber = selectfood.food.dietaryfiber * ( selectfood.weight / 100 )
            return totalDietaryFiber + dietaryFiber
        }
    }
    
    var totalWater: Double {
        selectedFoods.reduce(0) { totalWater, selectfood in
            let water = selectfood.food.water * ( selectfood.weight / 100 )
            return totalWater + water
        }
    }
    
    var totalWeight: Double {
        selectedFoods.reduce(0) { totalWeight, selectFood in
            let weight = selectFood.weight
            return totalWeight + weight
        }
    }
    
    func add(selectFood: SelectFood, to foodList:[SelectFood])  -> [SelectFood] {
        var foodList = foodList
        foodList.append(selectFood)
        return foodList
    }
    
    func delete(selectFood: SelectFood, from foodList: [SelectFood]) -> [SelectFood]{
        var foodList = foodList
        for i in 0...(foodList.count - 1) {
            if foodList[i].food.id == selectFood.food.id {
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

//これは食品交換表に対して行うもの
//SelectFoodsには行わない


//元々のTableを表現する機能と
//せぇctされたTableを表現する機能に分ける必要がある。
//イニシャライズ
class SelectFoodTableUseCaseTest: XCTestCase {
    
    let foodTableUseCase = SelectFoodTableUseCase()
    
    let selectFood
    = SelectFood(food:
                    FoodComposition(food:
                                        FoodCompositionRealm(id: 2,
                                                             protein: 1,
                                                             category: "")),
                 weight: 50)
    
    //nonEffected
    let testSelectFoods = [
        SelectFood(food: FoodComposition(food: FoodCompositionRealm(id: 1,protein: 20,category: "１ 穀類")),
                   weight: 100),
        SelectFood(food: FoodComposition(food: FoodCompositionRealm(id: 2,protein: 40,category: "２ いも及びでん粉類")),
                   weight: 100),
        SelectFood(food: FoodComposition(food: FoodCompositionRealm(id: 3,protein: 100,category: "２ いも及びでん粉類")),
                   weight: 100)
    ]
    
    let testTableFoods = [
        FoodComposition(food: FoodCompositionRealm(id: 1,protein: 20,category: "１ 穀類")),
        FoodComposition(food: FoodCompositionRealm(id: 2,protein: 40,category: "２ いも及びでん粉類")),
        FoodComposition(food: FoodCompositionRealm(id: 3,protein: 100,category: "２ いも及びでん粉類"))
    ]
    
    func test_配列に含まれた食品総数の算出(){
        foodTableUseCase.selectedFoods = testSelectFoods
        let totalFoodsCount = foodTableUseCase.totalSelectedFoodCount
        XCTAssertEqual(totalFoodsCount, testSelectFoods.count)
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
    
    func test_栄養素量_nilでのフィルタリング_空の配列が返されること() {
        //状態
        
        //操作
        let filterdFoods = testTableFoods.filterFoods(by: .protein(min: nil, max: nil))
        //検証
        let expected:[FoodComposition] = []
        XCTAssertEqual(filterdFoods, expected)
    }
    
    func test_栄養素量でのフィルタリング_栄養素の値含むの範囲内で返されること() {
        //状態
        
        //操作
        let filterdFoods = testTableFoods.filterFoods(by: .protein(min: 20, max: 50))
        //検証
        let expected:[FoodComposition] = [
            FoodComposition(food: FoodCompositionRealm(id: 1,
                                                       protein: 20,
                                                       category: "１ 穀類")),
            FoodComposition(food: FoodCompositionRealm(id: 2,
                                                       protein: 40,
                                                       category: "２ いも及びでん粉類"))
        ]
        
        XCTAssertEqual(filterdFoods, expected)
    }
    
    func test_栄養素カテゴリ名でのフィルタリング_カテゴリ名が一致する要素のみ返されること() {
        //状態
        
        //操作
        let filterdFoods = testTableFoods.filterFoods(by: .category(.koku))
        //検証
        let expected:[FoodComposition] = [
            FoodComposition(food: FoodCompositionRealm(id: 1,
                                                       protein: 20,
                                                       category: "１ 穀類"))
        ]
        
        XCTAssertEqual(filterdFoods, expected)
    }
    
    func test_カテゴリ名によるソート_返される配列に変化がないこと() {
        //状態
        
        //操作
        let sortedSelectFoods = testTableFoods.sortedFoods(by: .category(.imo))
        //検証
        let expected = testTableFoods
        
        XCTAssertEqual(sortedSelectFoods, expected)
    }
    
    func test_引数nilでの栄養素名による昇順ソート_指定された栄養素の重量で昇順に並んだ配列が返される() {
        //状態
        
        //操作
        let sortedSelectFoods = testTableFoods.sortedFoods(by: .protein(min: nil, max: nil))
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
    
    func test_引数ありでの栄養素名による昇順ソート_指定された栄養素の重量で昇順に並んだ配列が返される() {
        //状態
        
        //操作
        let sortedSelectFoods = testTableFoods.sortedFoods(by: .protein(min: 20, max: 50))
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
    
    func test_選択された食品一覧へのの追加_追加する配列の元の要素数に１が加算された値が返されること() {
        //状態
        
        //操作
        let addedSelectFoodList = foodTableUseCase.add(selectFood: selectFood, to: testSelectFoods)
        //検証
        XCTAssertEqual(addedSelectFoodList.count, testTableFoods.count + 1)
    }
    
    func test_選択された食品一覧からの削除_削除する配列の元の要素数に１を減じた値が返されること() {
        //状態
        
        //操作
        let deletedSelectFoodList = foodTableUseCase.delete(selectFood: selectFood, from: testSelectFoods)
        //検証
        XCTAssertEqual(deletedSelectFoodList.count, testSelectFoods.count - 1)
    }
}
//FoodTableUseCaseTest.defaultTestSuite.run()

let globalSuite = XCTestSuite(name: "Global - All tests")
globalSuite.addTest(SelectFoodTableUseCaseTest.defaultTestSuite)
globalSuite.run()

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


