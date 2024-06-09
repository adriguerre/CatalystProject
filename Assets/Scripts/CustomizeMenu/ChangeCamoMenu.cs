using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class ChangeCamoMenu : MonoBehaviour
{
    
    public static ChangeCamoMenu Instance;
    
    [SerializeField] private Button quitButton;

    private int currentCamoShowing = 0;
    private int currentCamoIndex = 0;
    [Header("Camo Buttons")]
    [SerializeField] private Button desertCamoButton;
    [SerializeField] private Button standardCamoButton;
    [SerializeField] private Button urbanCamoButton;
    [SerializeField] private Button winterCamoButton;
    [SerializeField] private Button woodLandCamoButton;
    [Header("Camo Game Objects")]
    [SerializeField] private GameObject desertCamoGameObject;
    [SerializeField] private GameObject standardCamoGameObject;
    [SerializeField] private GameObject urbanCamoGameObject;
    [SerializeField] private GameObject winterCamoGameObject;
    [SerializeField] private GameObject woodLandCamoGameObject;

    [Header("Select Camo Buttons")] 
    [SerializeField] private List<Button> desertCamoButtons;
    [SerializeField] private List<Button> standardCamoButtons;
    [SerializeField] private List<Button> urbanCamoButtons;
    [SerializeField] private List<Button> winterCamoButtons;
    [SerializeField] private List<Button> woodLandCamoButtons;

    [Header("Camo Materials")] 
    [SerializeField] private List<Material> desertCamoMaterials;
    [SerializeField] private List<Material> standardCamoMaterials;
    [SerializeField] private List<Material> urbanCamoMaterials;
    [SerializeField] private List<Material> winterCamoMaterials;
    [SerializeField] private List<Material> woodLandCamoMaterials;

    private void Awake()
    {
        if (Instance != null)
        {
            Destroy(this);
        }
        Instance = this; 
    }

    void Start()
    {
        quitButton.onClick.AddListener(() =>  DesactivateMenu());
        
        desertCamoButton.onClick.AddListener(() => ChangeCamosShown(0));
        standardCamoButton.onClick.AddListener(() => ChangeCamosShown(1));
        urbanCamoButton.onClick.AddListener(() => ChangeCamosShown(2));
        winterCamoButton.onClick.AddListener(() => ChangeCamosShown(3));
        woodLandCamoButton.onClick.AddListener(() => ChangeCamosShown(4));

        AddListeners(desertCamoButtons);
        AddListeners(standardCamoButtons);
        AddListeners(urbanCamoButtons);
        AddListeners(winterCamoButtons);
        AddListeners(woodLandCamoButtons);
    }

  
    void Update()
    {
        
    }

    private void AddListeners(List<Button> buttons)
    {
        for (int i = 0; i < buttons.Count; i++)
        {
            buttons[i].onClick.AddListener((() => SelectMaterial()));
        }
    }

    private void SelectMaterial()
    {
        GameObject clickedButton = EventSystem.current.currentSelectedGameObject; 
        Debug.Log(clickedButton);

        CamoButton camo = clickedButton.gameObject.GetComponent<CamoButton>();
        Material material = camo.GetMaterial();
        currentCamoIndex = camo.GetMaterialID();
        ChangeCamoIndex(currentCamoIndex);
        SkinnedMeshRenderer mesh = null;
        
        mesh = ShopManager.Instance.GetCurrentClothTesting().GetComponent<SkinnedMeshRenderer>();
        
        
        mesh.material = material;
    }

    private void ChangeCamoIndex(int newIndex)
    {
        List<int> camoIndexList = CharacterSelectorManager.Instance.GetUnitCamoIndexList();
        switch (ShopManager.Instance.GetCurrentFilter())
        {
            case ItemType.Headgear:
                camoIndexList[3] = newIndex;
                break;
            case ItemType.Pants:
                camoIndexList[4] = newIndex;
                break; 
            case ItemType.Shirts:
                camoIndexList[0] = newIndex;
                break; 
            case ItemType.ExtraEquip:
                camoIndexList[2] = newIndex;
                break;
            case ItemType.Bag:
                camoIndexList[1] = newIndex;
                break;
        }
        
    }

    private int GetCurrentCamoIndex()
    {
        return currentCamoIndex;
    }

    public void SetCamoIndex()
    {
        currentCamoIndex = -1;
    }
    
    public void DesactivateMenu()
    {
        CharacterSelectorManager.Instance.BackToMenu();
    }
    /// <summary>
    ///     0 - Desert
    ///     1 - Standard
    ///     2 - Urban
    ///     3 - Winter
    ///     4 - Woodland
    /// </summary>
    /// <param name="CamoIndex"></param>
    private void ChangeCamosShown(int camoIndex)
    {
        DesactivateCurrentCamo();
        currentCamoShowing = camoIndex;
        switch (camoIndex)
        {
            case 0:
                desertCamoGameObject.SetActive(true);
                break; 
            case 1: 
                standardCamoGameObject.SetActive(true);
                break;
            case 2: 
                urbanCamoGameObject.SetActive(true);
                break; 
            case 3: 
                winterCamoGameObject.SetActive(true);
                break; 
            case 4: 
                woodLandCamoGameObject.SetActive(true);
                break;
        }
    }

    private void DesactivateCurrentCamo()
    {
        switch (currentCamoShowing)
        {
            case 0:
                desertCamoGameObject.SetActive(false);
                break; 
            case 1: 
                standardCamoGameObject.SetActive(false);
                break;
            case 2: 
                urbanCamoGameObject.SetActive(false);
                break; 
            case 3: 
                winterCamoGameObject.SetActive(false);
                break; 
            case 4: 
                woodLandCamoGameObject.SetActive(false);
                break;
        }
    }

    public List<Button> GetDesertButtons()
    {
        return desertCamoButtons;
    }   
    public List<Button> GetStandardButtons()
    {
        return standardCamoButtons;
    }   
    public List<Button> GetUrbanButtons()
    {
        return urbanCamoButtons;
    }   
    public List<Button> GetWinterButtons()
    {
        return winterCamoButtons;
    }  
    public List<Button> GetWoodButtons()
    {
        return woodLandCamoButtons;
    }
    
}
