using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;

public class MoneyManager : MonoBehaviour
{
    
    public static MoneyManager Instance { get; private set; }
    
    [SerializeField] private int currentMoney;
    [SerializeField] private TextMeshProUGUI moneyText;

    private void Awake()
    {
        if (Instance != null)
        {
            Debug.LogError("There is already a MoneyManager!");
            Destroy(this);
        }
        Instance = this;
    }

    private void Start()
    {
        //We should load the money the player have, for now, it will be 10000
        currentMoney = 100000;
        WriteMoney();
    }

    private void Update()
    {
       //TODO: This is just for testing purpuses
       if (Input.GetKeyDown(KeyCode.Q))
       {
           AddMoney(2000);
       }
       if (Input.GetKeyDown(KeyCode.E))
       {
           RemoveMoney(2000);
       }
    }

    public void WriteMoney()
    {
        moneyText.text = currentMoney.ToString();
    }

    public int GetCurrentMoney()
    {
        return currentMoney;
    }

    public void AddMoney(int money)
    {
        this.currentMoney += money; 
        WriteMoney();
    }

    public void RemoveMoney(int money)
    {
        if (currentMoney - money < 0)
            this.currentMoney = 0;
        else
            this.currentMoney -= money; 
        
        WriteMoney();

    }
}
