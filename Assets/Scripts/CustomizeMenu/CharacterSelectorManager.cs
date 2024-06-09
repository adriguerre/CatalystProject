
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

public class CharacterSelectorManager : MonoBehaviour
{
    public enum CharacterSelectorStatus { soldierNotSelected, soldierSelected, customizingSoldier, customizingSoldierCamo}
    
    public static CharacterSelectorManager Instance { get; private set; }

    [Header("Soldier Showings Properties")]
    private int soldierIndexShowing;
    [SerializeField] private GameObject soldierShowing;
    [SerializeField] private List<GameObject> soldiers;
    [Header("Customize Button")]
    [SerializeField] private Button customizeButton;
    [SerializeField]private Image customizeImage;
    [SerializeField] private GameObject soldierSelectionGameObject;
    [Header("Info Button")]
    [SerializeField] private Button infoButton;
    [SerializeField] private Image infoImage;
    [Header("Button Sprites Properties")]
    [SerializeField] private Sprite GreenButton;
    [SerializeField] private Sprite WhiteButton;
    [Header("Menu Status")]
    private CharacterSelectorStatus menuStatus;

    [Header("Items Shop")]
    [SerializeField] private GameObject itemsShopGameObject;
    [Header("Camo Game Object")]
    [SerializeField] private GameObject camoMenuGameObject;
    [SerializeField] private Button changeCamoButton;
    [Header("Meshes renderer")]
    [SerializeField] private List<GameObject> bodyMeshes;
    [SerializeField] private List<GameObject> extraGearMeshes;
    [SerializeField] private List<GameObject> bagGearMeshes;
    [SerializeField] private List<GameObject> headMeshes;
    [SerializeField] private List<GameObject> legMeshes;
    private SkinnedMeshRenderer[] skinnedMeshlist;
    [SerializeField] private List<GameObject> currentClothes;
    [SerializeField] private List<int> currentClothesIndex;
    [SerializeField] private List<int> objectsBoughtWithCharacter;
    [SerializeField] private List<int> itemsUnlockedForThisCharacter;
    /// <summary>
    /// 0 - Body
    /// 1 - Extra bag
    /// 2 - Extra equip
    /// 3 - Head
    /// 4 - Legs 
    /// </summary>

    private void Awake()
    {
        if (Instance != null)
        {
            Debug.LogError("There is more than one CharacterSelectorManager");
            Destroy(this);
        }
        Instance = this; 

    }
    
    private void Start()
    {


        soldierSelectionGameObject.SetActive(true);
        itemsShopGameObject.SetActive(false);
        camoMenuGameObject.SetActive(false);
        customizeButton.enabled = false;
        infoButton.enabled = false;
       
        menuStatus = CharacterSelectorStatus.soldierNotSelected;
        customizeButton.onClick.AddListener(() => CustomizeSoldierButtonClicked());
        infoButton.onClick.AddListener(() => InfoSoldierButtonClicked());
        changeCamoButton.onClick.AddListener(() => ActivateChangeCamoMenu());
        
        /*GetPersonalMeshes(soldiers[0], 0);
        GetPersonalMeshes(soldiers[1], 1);
        GetPersonalMeshes(soldiers[2], 2);
        GetPersonalMeshes(soldiers[3], 3);
        */
    }

    public GameObject GetSoldierShowingPrefab()
    {
        return soldierShowing;
    }


    
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            BackToMenu();
        }
        
        if (menuStatus != CharacterSelectorStatus.soldierNotSelected)
        {
            customizeButton.enabled = true;
            infoButton.enabled = true;
            infoImage.color = Color.white;
            customizeImage.color = Color.white;
        }

        if (ShopManager.Instance.GetSelectedItem() != null)
        {
            changeCamoButton.enabled = true;
        }
        else
        {
            changeCamoButton.enabled = false;
        }
    }

    public void UpdateCurrentClothes(GameObject removeCloth, GameObject newCloth, ItemType filter, int newIndex)
    {
       int index = currentClothes.IndexOf(removeCloth);
       currentClothes[index] = newCloth;

       switch (filter)
       {
           case ItemType.Shirts:
               currentClothesIndex[0] = newIndex;
               break; 
           case ItemType.Bag:
               currentClothesIndex[1] = 11 + newIndex;
               break;
           case ItemType.ExtraEquip:
               currentClothesIndex[2] = 14 + newIndex;
               break;
           case ItemType.Headgear:
               currentClothesIndex[3] = 17 + newIndex;
               break;
           case ItemType.Pants:
               currentClothesIndex[4] = 69 + newIndex;
               break; 
       }
    }
    

    public void SpawnSoldier(int soldierIndex)
    {
        soldierIndexShowing = soldierIndex;
        Destroy(soldierShowing);
        GameObject newSoldier = Instantiate(soldiers[soldierIndex], new Vector3(0.62f, -0.24f, -3.33f),
            Quaternion.identity);
        soldierShowing = newSoldier;
        menuStatus = CharacterSelectorStatus.soldierSelected;
        
        //Load outfit - When we recruit a soldier, we need to save his initial outfit
        //First we check if we have an available save, if not, we dont load
        UnitCharacterOutfitData auxData = new UnitCharacterOutfitData();
        auxData = SaveManager.Instance.TryLoadPlayerOutfitJson(soldierIndexShowing);
        if (auxData != null)
        {
            if (auxData.outfitsIDWithCamoDictionary.Count != 0)
            {
                //Clear current clothes
                ClearAllMeshesList();
                //Desactivate current clothes
                skinnedMeshlist = soldierShowing.GetComponentsInChildren<SkinnedMeshRenderer>();
                foreach (SkinnedMeshRenderer skin in skinnedMeshlist)
                {
                    skin.gameObject.SetActive(false);
                }
                //Activate new Clothes
                GetMeshes();
                ActivateLoadedClothes(auxData);   
            }
            else
            {
                SavePlayer(auxData);
            }
        }
        else
        {
          SavePlayer(auxData);
        }

        itemsUnlockedForThisCharacter = auxData.unlockedItemsID;
    }

    private void SavePlayer(UnitCharacterOutfitData auxData)
    {
        ClearAllMeshesList();
        GetMeshes();
        GetPersonalMeshesId(soldierShowing, soldierIndexShowing);
        auxData = GetPersonalMeshesToSave(soldierShowing, soldierIndexShowing);
        SaveManager.Instance.SavePlayerOutfitJson(soldierIndexShowing, auxData);
    }
    
    private void ActivateLoadedClothes(UnitCharacterOutfitData data)
    {
        ItemSaveData aux = new ItemSaveData(0,0);
        if(data.outfitsIDWithCamoDictionary.TryGetValue(0, out aux))
        {
            Debug.Log(aux.outfitID);
            GameObject body = bodyMeshes[aux.outfitID];
            AddGameObjectsToList(body, aux.outfitID, aux.camouflageID);
        }
        else
        {
            Debug.Log(aux);
        }
        if (data.outfitsIDWithCamoDictionary.TryGetValue(1, out aux))
        {
            GameObject extraBag = bagGearMeshes[aux.outfitID - 11];
            AddGameObjectsToList(extraBag, aux.outfitID, aux.camouflageID);
        }
        if (data.outfitsIDWithCamoDictionary.TryGetValue(2, out aux))
        {
            GameObject extraEquip = extraGearMeshes[aux.outfitID - 14];
            AddGameObjectsToList(extraEquip, aux.outfitID, aux.camouflageID);
        }
        if (data.outfitsIDWithCamoDictionary.TryGetValue(3, out aux))
        {
            GameObject head = headMeshes[aux.outfitID - 17];
            AddGameObjectsToList(head, aux.outfitID, aux.camouflageID);
        }
        if (data.outfitsIDWithCamoDictionary.TryGetValue(4, out aux))
        {
            GameObject legs = legMeshes[aux.outfitID- 69];
            AddGameObjectsToList(legs, aux.outfitID, aux.camouflageID);
        }
    }
    private void AddGameObjectsToList(GameObject gameObject, int outfitID, int camoID)
    {
        gameObject.SetActive(true);
        //Change Camouflage
        SkinnedMeshRenderer skin = gameObject.GetComponent<SkinnedMeshRenderer>();
        skin.material = ChangeMaterial(camoID);
        currentClothes.Add(gameObject);
        currentClothesIndex.Add(outfitID);
    }

    private Material ChangeMaterial(int camoID)
    {
        if (camoID < 5)
            return ChangeCamoMenu.Instance.GetDesertButtons()[camoID].GetComponent<CamoButton>().GetMaterial();
        else if (camoID < 11)
            return ChangeCamoMenu.Instance.GetStandardButtons()[camoID - 6].GetComponent<CamoButton>().GetMaterial();
        else if(camoID < 17)
            return ChangeCamoMenu.Instance.GetUrbanButtons()[camoID - 11].GetComponent<CamoButton>().GetMaterial();
        else if(camoID < 22)
            return ChangeCamoMenu.Instance.GetWinterButtons()[camoID - 17].GetComponent<CamoButton>().GetMaterial();
        else
            return ChangeCamoMenu.Instance.GetWoodButtons()[camoID - 22].GetComponent<CamoButton>().GetMaterial();
    }
    
    private void InfoSoldierButtonClicked()
    {
        
    }


    public void SaveSoldierPrefab()
    {
        UnitCharacterOutfitData dataToSave = GetPersonalMeshesToSave(soldierShowing, soldierIndexShowing);
        SaveManager.Instance.SavePlayerOutfitJson(soldierIndexShowing, dataToSave);
        /*
        string localPath = "Assets/Prefabs/Soldier_" + (soldierIndexShowing + 1) + ".prefab";
        bool prefabSuccess;
        PrefabUtility.SaveAsPrefabAssetAndConnect(GetSoldierShowingPrefab(), localPath, InteractionMode.UserAction, out prefabSuccess);
        */
    }

    #region Button Methods
    public void BackToMenu()
    {
        SoundManager.Instance.ActivateButtonClickAudioClip();
        switch (menuStatus)
        {
            case CharacterSelectorStatus.soldierNotSelected:
                MenuManager.Instance.ReturnFromCustomize();
                break; 
            case CharacterSelectorStatus.soldierSelected: 
                MenuManager.Instance.ReturnFromCustomize();
                break; 
            case CharacterSelectorStatus.customizingSoldier:
                GoBackToCharacterSelectorGameObject();
                menuStatus = CharacterSelectorStatus.soldierNotSelected; 
                break;
            case CharacterSelectorStatus.customizingSoldierCamo: 
                DesactivateChangeCamoMenu();
                break;
        }
 
    }

    private void CustomizeSoldierButtonClicked()
    {
        SoundManager.Instance.ActivateButtonClickAudioClip();
        menuStatus = CharacterSelectorStatus.customizingSoldier; 
        soldierSelectionGameObject.SetActive(false);
        itemsShopGameObject.SetActive(true);
        customizeImage.sprite = GreenButton;
        ShopManager.Instance.ResetItemsSlots();
    }

    private void GoBackToCharacterSelectorGameObject()
    {
        SaveManager.Instance.SaveNewItemUnlockedInSoldier(soldierIndexShowing, objectsBoughtWithCharacter);
        ShopManager.Instance.ResetProperties();
        objectsBoughtWithCharacter.Clear();
        SoundManager.Instance.ActivateButtonClickAudioClip();
        soldierSelectionGameObject.SetActive(true);
        itemsShopGameObject.SetActive(false);
        customizeImage.sprite = WhiteButton;
    }

    public void AddBoughtItemToList(int itemID)
    {
        objectsBoughtWithCharacter.Add(itemID);
    }
    
    private void ActivateChangeCamoMenu()
    {
        menuStatus = CharacterSelectorStatus.customizingSoldierCamo;
        camoMenuGameObject.SetActive(true);
    }

    private void DesactivateChangeCamoMenu()
    {
        menuStatus = CharacterSelectorStatus.customizingSoldier;
        camoMenuGameObject.SetActive(false);
    }
    
    #endregion

    public void GetPersonalMeshesId(GameObject soldier, int soldierIndex)
    {
             //We get mesh renderer 
        skinnedMeshlist = soldier.GetComponentsInChildren<SkinnedMeshRenderer>(true);
        UnitCharacterOutfitData auxData = new UnitCharacterOutfitData();
        //Body
        for (int i = 0; i <= 10; i++)
        {
            if (skinnedMeshlist[i].gameObject.activeSelf)
            {
                currentClothesIndex.Add(i);
                break;
            }
        }
        //Bags
        for (int i = 11; i <= 13; i++)
        {
            if (skinnedMeshlist[i].gameObject.activeSelf)
            {
                currentClothesIndex.Add(i);
                break;
            }
        }
        //ExtraEquip
        for (int i = 14; i <= 16; i++)
        {
            if (skinnedMeshlist[i].gameObject.activeSelf)
            {
                currentClothesIndex.Add(i);
                break;
            }
        }
        //Heads
        for (int i = 17; i <= 68; i++)
        {
            if (skinnedMeshlist[i].gameObject.activeSelf)
            {
                currentClothesIndex.Add(i);
                break;
            }
        }
        //Legs
        for (int i = 69; i <= 71; i++)
        {
            if (skinnedMeshlist[i].gameObject.activeSelf)
            {
                currentClothesIndex.Add(i);
                break;
            }
        }

    }
    
    public UnitCharacterOutfitData GetPersonalMeshesToSave(GameObject soldier, int soldierIndex)
    {
          //We get mesh renderer 
        skinnedMeshlist = soldier.GetComponentsInChildren<SkinnedMeshRenderer>(true);
        List<int> camoIndexList = soldier.GetComponent<UnitData>().GetCamoIndexList();
        UnitCharacterOutfitData auxData = new UnitCharacterOutfitData();
        //Body
        for (int i = 0; i <= 10; i++)
        {
            if (skinnedMeshlist[i].gameObject.activeSelf)
            {
                auxData.outfitsIDWithCamoDictionary.Add(0, new ItemSaveData(i, camoIndexList[0]));
                break;
            }
        }
        //Bags
        for (int i = 11; i <= 13; i++)
        {
            if (skinnedMeshlist[i].gameObject.activeSelf)
            {
                auxData.outfitsIDWithCamoDictionary.Add(1, new ItemSaveData(i, camoIndexList[1]));
                break;
            }
        }
        //ExtraEquip
        for (int i = 14; i <= 16; i++)
        {
            if (skinnedMeshlist[i].gameObject.activeSelf)
            {
                auxData.outfitsIDWithCamoDictionary.Add(2, new ItemSaveData(i, camoIndexList[2]));
                break;
            }
        }
        //Heads
        for (int i = 17; i <= 68; i++)
        {
            if (skinnedMeshlist[i].gameObject.activeSelf)
            {              
                auxData.outfitsIDWithCamoDictionary.Add(3, new ItemSaveData(i, camoIndexList[3]));
                break;
            }
        }
        //Legs
        for (int i = 69; i <= 71; i++)
        {
            if (skinnedMeshlist[i].gameObject.activeSelf)
            {
                auxData.outfitsIDWithCamoDictionary.Add(4, new ItemSaveData(i, camoIndexList[4]));
                break;
            }
        }

        return auxData;
    }
    private void GetMeshes()
    {
        //We get mesh renderer 
        skinnedMeshlist = soldierShowing.GetComponentsInChildren<SkinnedMeshRenderer>(true);
        SkinnedMeshRenderer[] activeSkinnedMeshlist = soldierShowing.GetComponentsInChildren<SkinnedMeshRenderer>();

        //Body
        for (int i = 0; i <= 10; i++)
        {
            bodyMeshes.Add(skinnedMeshlist[i].gameObject);
        }
        //Bags
        for (int i = 14; i <= 16; i++)
        {
            
            extraGearMeshes.Add(skinnedMeshlist[i].gameObject);
        }
        //ExtraEquip
        for (int i = 11; i <= 13; i++)
        {
           
            bagGearMeshes.Add(skinnedMeshlist[i].gameObject);
        }
        //Heads
        for (int i = 17; i <= 68; i++)
        {
           
            headMeshes.Add(skinnedMeshlist[i].gameObject);
        }
        //Legs
        for (int i = 69; i <= 71; i++)
        {
            
            legMeshes.Add(skinnedMeshlist[i].gameObject);
        }

        foreach (SkinnedMeshRenderer mesh in activeSkinnedMeshlist)
        {
            currentClothes.Add(mesh.gameObject);
        }
    }

    public List<int> GetUnitCamoIndexList()
    {
        return soldierShowing.GetComponent<UnitData>().GetCamoIndexList();
    }
    
    #region Getters
    public List<GameObject> GetCurrentCloth()
    {
        return currentClothes;
    }
    public List<int> GetCurrentClothesIndex()
    {
        return currentClothesIndex;
    }

    public List<GameObject> GetHeadCloths()
    {
        return headMeshes;
    }   
    public List<GameObject> GetBodyCloths()
    {
        return bodyMeshes;
    }   
    public List<GameObject> GetLegsCloths()
    {
        return legMeshes;
    }   
    public List<GameObject> GetExtraCloths()
    {
        return extraGearMeshes;
    }  
    public List<GameObject> GetBagCloths()
    {
        return bagGearMeshes;
    }
    public int GetSoldierIndex()
    {
        return soldierIndexShowing;
    }

    public List<int> GetItemsUnlockedWithThisCharacter()
    {
        return itemsUnlockedForThisCharacter;
    }
    #endregion
    public void ClearAllMeshesList()
    {
        headMeshes.Clear();
        bodyMeshes.Clear();
        legMeshes.Clear();
        extraGearMeshes.Clear();
        bagGearMeshes.Clear();
        skinnedMeshlist = null;
        currentClothes.Clear();
        currentClothesIndex.Clear();
    }

  

    
    
}
