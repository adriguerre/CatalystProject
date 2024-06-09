using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Manager : MonoBehaviour
{
    public static Manager Instance; 
    
    public GameStatus gamestatus { get; private set; }

    private void Awake()
    {
        if (Instance != null)
        {
            Debug.LogWarning("[Manager] :: There is already a Manager");
        }
        Instance = this;

        gamestatus = GameStatus.Menu;
    }


    public void SetGameStatu(GameStatus gmStatus)
    {
        this.gamestatus = gmStatus;
    }
    
}
