using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CombatManager : MonoBehaviour
{
    public static CombatManager _instance;
    public static CombatManager Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = GameObject.FindObjectOfType<CombatManager>();

                if (_instance == null)
                {
                    GameObject container = new GameObject("Bicycle");
                    _instance = container.AddComponent<CombatManager>();
                }
            }

            return _instance;
        }
    }

   
    public AimingReticulis reticuleRef;
    private PlayerController playerRef;

    public void InitCombat()
    {
        //Open Combat Interface
    }

    public void SetPlayerReference(PlayerController player)
    {
        playerRef = player;
    }

    public void LaunchReticule()
    {
        reticuleRef.SetReticuleSize(CalculateRiticuleSize());
        reticuleRef.Launch(playerRef.ReturnCurrentClipLength());
    }

    private float CalculateRiticuleSize()
    {
        float clipLength = playerRef.ReturnCurrentClipLength();
        return reticuleRef.reticulisScaleFactor* clipLength;
    }
}

