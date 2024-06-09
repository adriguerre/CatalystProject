using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Item : MonoBehaviour
{
    
    [field: SerializeField] private int price;
    //[SerializeField] private string name = "Undefined"; 
    [SerializeField] private int id;
    [SerializeField] private string description;

    [Header("UI Properties")]
    [SerializeField] private Image itemIcon;
    [SerializeField] private TextMeshProUGUI priceText;

    [SerializeField] private GameObject itemIconGameObject;
    [SerializeField] private GameObject itemPriceGameObject;
    public bool unlocked
    {
        get => itemSO.unlocked;
        set => itemSO.unlocked = value;
    }
    [SerializeField] private bool _unlocked;

    private ItemSO itemSO;
    
    
       

    [SerializeField] private GameObject lockedGameObject;
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (itemSO != null)
        {
            if (unlocked)
            {
                lockedGameObject.SetActive(false);
            }
            else
            {
                lockedGameObject.SetActive(true);
            } 
        }
       
    }

    public string GetName()
    {
        return this.name; 
    }

    public int GetID()
    {
        return this.id;
    }

    public int GetPrice()
    {
        return this.price;
    }

    private void SetUnlocked(bool unlock)
    {
        this.unlocked = unlock;
    }

    public void EmptySlot()
    {
        itemPriceGameObject.SetActive(false);
        itemIconGameObject.SetActive(false);
    }

    public void ActivateSlot(Sprite newItemIcon, int itemPrice)
    {
        itemPriceGameObject.SetActive(true);
        itemIconGameObject.SetActive(true);
        
        price = itemPrice;
        priceText.text = itemPrice.ToString();
        itemIcon.sprite = newItemIcon;
    }

    public void SetItemSO(ItemSO itemSO)
    {
        this.itemSO = itemSO;
    }

    public ItemSO GetItemSO()
    {
        return itemSO;
    }
}
