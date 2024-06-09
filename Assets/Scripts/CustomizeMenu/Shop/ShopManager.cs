
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using UnityEngine.EventSystems;
public class ShopManager : MonoBehaviour
{

    public static ShopManager Instance;
    
    [SerializeField] private List<Button> itemSlotList;
    [SerializeField] private Button buyButton;
    private BuyEquipButton buyEquipButton;

    
    [SerializeField] private Item itemSelected;
    [SerializeField] private int itemSelectedIndex = 0;
    public Dictionary<ItemType, List<ItemSO>> shopItems;

    [Header("Items")]
    [SerializeField] private List<ItemSO> headItems; 
    [SerializeField] private List<ItemSO> bodyItems; 
    [SerializeField] private List<ItemSO> pantsItems; 
    [SerializeField] private List<ItemSO> extraEquipItems;
    [SerializeField] private List<ItemSO> extraBagItems;
    [Header("Filters Items Button")]
    [SerializeField] private Button headGearButton;
    [SerializeField] private Button bodyButton;
    [SerializeField] private Button pantsButton;
    [SerializeField] private Button extraEquipButton;
    [SerializeField] private Button extraBagsButton;
    [Header("Current Filter")]
    [SerializeField] private ItemType currentFilter = ItemType.Undefined;
    [Header("Items Showing")]
    [SerializeField] private List<GameObject> itemsShowing;
    [Header("UI Hovers")]
    [SerializeField] private Sprite greenButtonSprite;
    [SerializeField] private Sprite emptySprite;

    [Header("Testing cloths")] 
    [SerializeField] private List<GameObject> clothWearing;
    [SerializeField] private GameObject currentClothWearing;
    [SerializeField] private GameObject currentClothTesting;

    private bool isBuying = false;
    
    private void Awake()
    {
        if (Instance != null)
        {
            Debug.LogWarning("[ShopManager] :: There is already a shop manager");
            Destroy(this.gameObject);
        }
        Instance = this;
    }

    void Start()
    {
        shopItems = new Dictionary<ItemType, List<ItemSO>>();
        buyEquipButton = buyButton.GetComponent<BuyEquipButton>();
        itemSelected = null;
        foreach (Button itemSlot in itemSlotList)
        { 
            itemSlot.onClick.AddListener(() => ItemSelected());
            itemsShowing.Add(itemSlot.gameObject);
        }

        buyButton.onClick.AddListener(() => BuyItem());
 
        //Filter Buttons
        headGearButton.onClick.AddListener(() => SetFilter(ItemType.Headgear));
        bodyButton.onClick.AddListener(() =>  SetFilter(ItemType.Shirts));
        pantsButton.onClick.AddListener(() =>  SetFilter(ItemType.Pants));
        extraEquipButton.onClick.AddListener(() =>  SetFilter(ItemType.ExtraEquip));
        extraBagsButton.onClick.AddListener(() =>  SetFilter(ItemType.Bag));

        shopItems.Add(ItemType.Headgear, headItems);
        shopItems.Add(ItemType.Shirts, bodyItems);
        shopItems.Add(ItemType.Pants, pantsItems);
        shopItems.Add(ItemType.ExtraEquip, extraEquipItems);
        shopItems.Add(ItemType.Bag, extraBagItems);
        
        SetFilter(ItemType.Headgear);
    }

    // Update is called once per frame
    void Update()
    {
 
        if (itemSelected != null)
        {
            buyButton.enabled = true;
            if (itemSelected.GetItemSO() != null)
            {
                
                if (itemSelected == null)
                {
                    buyButton.enabled = false;
                }
            }
        }
        else
        {
            buyButton.enabled = false;
        }
    }



    /// <summary>
    /// Method called whenever we click an item Slot
    /// </summary>
    private void ItemSelected()
    {
        //We check what itemSlot we picked
        GameObject clickedButton = EventSystem.current.currentSelectedGameObject; 
        Item item = clickedButton.gameObject.GetComponent<Item>();
        //Change properties
        itemSelected = item;
        itemSelectedIndex = itemSelected.GetID();
        //Put item on soldier - PREVISUALISATION
        if (itemSelected.GetItemSO() != null)
        {
            CheckBuyButton();
            //First, we disable the element we are testing
            DisableCloth();
            //Activate the item we are looking
            ActivateNewCloth(itemSelectedIndex);
        }
        else
        {
            //In case it is a empty Item slot
            itemSelected = null;
        }
    }
    
    #region BUY_EQUIP_EQUIPPED_BUTTON 
    
    /// <summary>
    /// Method to Write different things in BUY button, which are Buy, EQUIP or EQUIPPED 
    /// </summary>
    private void CheckBuyButton()
    {
        List<int> clothesIndexList = CharacterSelectorManager.Instance.GetCurrentClothesIndex();
        if (clothesIndexList.Contains(itemSelected.GetItemSO().itemID))
        {
            buyEquipButton.WriteInTextEquipped();
            buyButton.interactable = false;
        }
        else
        {
            WriteButton(itemSelected.GetItemSO());
            buyButton.interactable = true;
        }
    }
    /// <summary>
    /// Check if we have to write BUY OR EQUIP
    /// </summary>
    /// <param name="item"></param>
    private void WriteButton(ItemSO item)
    {
        if (item != null)
        {
            if (item.unlocked)
            {
                    buyEquipButton.WriteInTextEquip();
                    buyEquipButton.enabled = true;
            }
            else
            {
                buyEquipButton.WriteInTextBuy();
            }  
        }
    }

    #endregion

    #region BUY_ITEM
    /// <summary>
    /// Method to Equip or buy an item depending if it is bought or not
    /// </summary>
    private void BuyItem()
    {
        switch (buyEquipButton.GetCanEquipItem())
        {
            case true:
                //Sound 
                SoundManager.Instance.ActivateEquipItemAudioClip();
                //Update Clothes List
                CharacterSelectorManager.Instance.UpdateCurrentClothes(currentClothWearing, currentClothTesting, currentFilter, itemSelectedIndex);
                CheckBuyButton();
                //Equip behavior
                currentClothWearing = currentClothTesting;
                currentClothTesting = null;
                //Save Prefab
                CharacterSelectorManager.Instance.SaveSoldierPrefab();
                break; 
            case false:
                if (MoneyManager.Instance.GetCurrentMoney() >= itemSelected.GetPrice())
                {
                    //Start Coroutine
                    isBuying = true;
                    StartCoroutine(StartBuyAnimationCoroutine());
                }
                break;
        }
    }

    private void StopBuying()
    {
        isBuying = false;
        StopAllCoroutines();
    }

    private IEnumerator StartBuyAnimationCoroutine()
    {
        while (isBuying)
        {
            yield return new WaitForSeconds(0f);
            Buy();
            yield return null;
        }
    }
    
    private void Buy()
    {
        //Start Coroutine
        itemSelected.unlocked = true;
        WriteButton(itemSelected.GetItemSO());
        MoneyManager.Instance.RemoveMoney(itemSelected.GetPrice());
        SoundManager.Instance.ActivateButtonClickAudioClip();
        CharacterSelectorManager.Instance.AddBoughtItemToList(itemSelected.GetItemSO().itemID);
        StopAllCoroutines();
        isBuying = false;
    }
    #endregion

    public void ResetItemsSlots()
    {
        currentFilter = ItemType.Undefined;
        SetFilter(ItemType.Headgear);
    }
    
    private void SetFilter(ItemType nextFilter)
    {
        if (nextFilter != currentFilter)
        {
            //Activate audio clip 
            SoundManager.Instance.ActivateButtonClickAudioClip();
            //Swap filter sprite 
            SwapFilterButtonSprite(nextFilter);
            
            this.currentFilter = nextFilter;
            //Clear items UI
            foreach (GameObject slotItem in itemsShowing)
            {
                Item item = slotItem.GetComponent<Item>();
                item.EmptySlot();
            }
            itemsShowing.Clear();
            //Set new Items UI
            List<ItemSO> newItemsToShow = new List<ItemSO>();
            if (shopItems.TryGetValue(nextFilter, out newItemsToShow))
            {
                for (int i = 0; i < newItemsToShow.Count; i++)
                {
                    Item item = itemSlotList[i].GetComponent<Item>();
                    ItemSO itemSO = newItemsToShow[i];
                    
                    item.SetItemSO(itemSO);
                    Sprite itemIcon = itemSO.itemSprite;
                    int price = itemSO.itemPrice;
                    //Check if it is bought for this character
                    if (CharacterSelectorManager.Instance.GetItemsUnlockedWithThisCharacter()
                        .Contains(itemSO.itemID))
                    {
                        Debug.Log("UNLOCKED" + itemSO.itemID);
                        item.unlocked = true;
                    }
                    else
                    {
                        item.unlocked = false;
                    }
                   
                    item.ActivateSlot(itemIcon, price);
                    itemsShowing.Add(item.gameObject);
                }
            }
        }
    }
    
    private void SwapFilterButtonSprite(ItemType nextFilter)
    {
        ClearOlderFilterSprite();
        Image image = null;
        switch (nextFilter)
        {
            case ItemType.Headgear:
                image = headGearButton.gameObject.GetComponent<Image>();
                break;
            case ItemType.Pants: 
                image = pantsButton.gameObject.GetComponent<Image>();
                break; 
            case ItemType.Shirts: 
                image = bodyButton.gameObject.GetComponent<Image>();
                break; 
            case ItemType.ExtraEquip: 
                image = extraEquipButton.gameObject.GetComponent<Image>();
                break;
            case ItemType.Bag: 
                image = extraBagsButton.gameObject.GetComponent<Image>();
                break;
        }
        image.sprite = greenButtonSprite;
    }

   private void ClearOlderFilterSprite()
   {
       Image image = null;
        switch (currentFilter)
        {
            case ItemType.Headgear:
                 image = headGearButton.gameObject.GetComponent<Image>();
                break;
            case ItemType.Pants: 
                 image = pantsButton.gameObject.GetComponent<Image>();
                break; 
            case ItemType.Shirts: 
                 image = bodyButton.gameObject.GetComponent<Image>();
                break; 
            case ItemType.ExtraEquip: 
                 image = extraEquipButton.gameObject.GetComponent<Image>();
                break;
            case ItemType.Bag: 
                image = extraBagsButton.gameObject.GetComponent<Image>();
                break;
        }

        if (image != null)
        {
            image.sprite = emptySprite; 
        }
    }
   

   private void DisableCloth()
   {
       clothWearing = CharacterSelectorManager.Instance.GetCurrentCloth();
       if (currentClothWearing != null) //First test
       {
           currentClothWearing.SetActive(true);
       }
    
       switch (currentFilter)
       {
           case ItemType.Headgear:
               currentClothWearing = clothWearing[3];
               currentClothWearing.SetActive(false);
               break;
           case ItemType.Pants:
               currentClothWearing = clothWearing[4];
               currentClothWearing.SetActive(false);
               break; 
           case ItemType.Shirts:
               currentClothWearing = clothWearing[0];
               currentClothWearing.SetActive(false);
               break; 
           case ItemType.ExtraEquip:
               currentClothWearing = clothWearing[2];
               currentClothWearing.SetActive(false);
               break;
           case ItemType.Bag:
               currentClothWearing = clothWearing[1];
               currentClothWearing.SetActive(false);
               break;
       }
   }

   private void ActivateNewCloth(int itemIndex)
   {
       List<GameObject> gameObjects = null;
       if (currentClothTesting != null)
       {
           currentClothTesting.SetActive(false);
       }
       switch (currentFilter)
       {
           case ItemType.Headgear:
               gameObjects = CharacterSelectorManager.Instance.GetHeadCloths();
               currentClothTesting = gameObjects[itemIndex];
               break;
           case ItemType.Pants:
               gameObjects = CharacterSelectorManager.Instance.GetLegsCloths();
               break; 
           case ItemType.Shirts:
               gameObjects = CharacterSelectorManager.Instance.GetBodyCloths();
               break; 
           case ItemType.ExtraEquip:
               gameObjects = CharacterSelectorManager.Instance.GetExtraCloths();
               break;
           case ItemType.Bag:
               gameObjects = CharacterSelectorManager.Instance.GetBagCloths();
               break;
       }
       currentClothTesting = gameObjects[itemIndex];
       currentClothTesting.SetActive(true);
   }

   public void ResetProperties()
   {
       if(currentClothTesting != null)
        currentClothTesting.SetActive(false);
       if(currentClothWearing != null) 
        currentClothWearing.SetActive(true);
       currentClothTesting = null;
       currentClothWearing = null;
       
       //Reset characterSelectorManager list (Clear)
       CharacterSelectorManager.Instance.ClearAllMeshesList();
   }

   public Item GetSelectedItem()
   {
       return itemSelected;
   }

   public GameObject GetCurrentClothTesting()
   {
       return currentClothTesting;
   }
   public GameObject GetCurrentClothWearing()
   {
       return currentClothWearing;
   }

   public ItemType GetCurrentFilter()
   {
       return currentFilter;
   }
}
